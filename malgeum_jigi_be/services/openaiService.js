import OpenAI from "openai";
import dotenv from "dotenv";
dotenv.config();

const openai = new OpenAI({
  apiKey: process.env.OPENAI_KEY,
});

/**
 * 환기 점수 및 설명 생성
 * @param {number} temperature - 기온 (°C)
 * @param {number} humidity - 습도 (%)
 * @param {number} rainfall - 강수량 (mm)
 * @param {number} pm10 - 미세먼지 (㎍/㎥)
 */
export async function generateVentilationScore(temperature, humidity, rainfall, pm10) {
  const prompt = `
  아래 데이터를 바탕으로 0~100점 사이의 환기 점수를 평가해줘.
  점수가 높을수록 환기하기 좋은 환경이야.
  그리고 상태(status), 이모지(emoji), 간단한 설명(description)을 함께 반환해줘.

  - 기온: ${temperature}℃
  - 습도: ${humidity}%
  - 강수량: ${rainfall}mm
  - 미세먼지: ${pm10}㎍/㎥

  응답은 다른 문자열 없이 아래 예시처럼 JSON 자체만 출력해줘.

  예시:
  {
    "score": 78,
    "status": "좋음",
    "emoji": "😊",
    "description": "신선한 공기가 충분하니 창문을 열어 환기하기 좋은 시간입니다."
  }
  `;

  const completion = await openai.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [{ role: "user", content: prompt }],
  });

  try {
    const jsonText = completion.choices[0].message.content.trim();
    return JSON.parse(jsonText);
  } catch (err) {
    console.error("⚠️ OpenAI 응답 파싱 오류:", err);
    return {
      score: 50,
      status: "보통",
      emoji: "😐",
      description: "환기 점수를 계산하는 중 오류가 발생했습니다.",
    };
  }
}

/**
 * 외출 가이드 생성
 * @param {number} temperature - 기온 (°C)
 * @param {number} humidity - 습도 (%)
 * @param {number} rainfall - 강수량 (mm)
 * @param {number} pm10 - 미세먼지 (㎍/㎥)
 */
export async function generateOutdoorGuide(temperature, humidity, rainfall, pm10) {
  const prompt = `
  다음은 현재 기상 및 공기질 데이터입니다.
  이 정보를 기반으로 외출 권고도(advisability), 한 줄 요약(summary),
  그리고 권장 활동(recommendations)을 포함하는 JSON을 만들어줘.

  - 기온: ${temperature}℃
  - 습도: ${humidity}%
  - 강수량: ${rainfall}mm
  - 미세먼지: ${pm10}㎍/㎥

  응답은 다른 문자열 없이 아래 예시처럼 JSON 자체만 출력해줘.
  예시:
  {
    "advisability": "추천",
    "summary": "현재 공기질이 양호하여 야외 활동하기 좋은 시간입니다.",
    "recommendations": [
      "산책이나 조깅하기 좋은 시간입니다",
      "자외선 차단제를 발라주세요"
    ]
  }
  `;

  const completion = await openai.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [{ role: "user", content: prompt }],
  });

  try {
    const jsonText = completion.choices[0].message.content.trim();
    return JSON.parse(jsonText);
  } catch (err) {
    console.error("⚠️ OpenAI 응답 파싱 오류:", err);
    return {
      advisability: "주의",
      summary: "외출 가이드를 생성하는 중 오류가 발생했습니다.",
      recommendations: ["실내 활동을 권장합니다."],
    };
  }
}

export async function generateApplianceGuide(weatherData) {
  const prompt = `
  당신은 기상 데이터를 기반으로 생활 가이드를 생성하는 스마트 도우미입니다.
  다음은 오늘의 시간대별 온도와 습도 데이터입니다:
  ${JSON.stringify(weatherData, null, 2)}

  이 데이터를 참고하여 다음 세 가지 가전에 대한 사용 가이드를 작성하세요.
  각 항목은 다음 구조를 따라야 합니다:
  [
    {
      "name": "난방",
      "status": "필요" 또는 "불필요",
      "time": "사용 추천 시간대 (예: 오전 6시 ~ 9시)" 또는 null,
      "reason": "추천 또는 불필요 사유",
      "setting": "권장 설정 (예: 실내 온도 20~22°C 유지)" 또는 null
    },
    {
      "name": "에어컨",
      ...
    },
    {
      "name": "제습기",
      ...
    }
  ]

  주의사항:
  - 반드시 JSON 배열만 출력하세요. (예: [ { ... }, { ... }, { ... } ])
  - 코드블럭이나 설명 텍스트를 포함하지 마세요.
  `;

  const completion = await openai.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [{ role: "user", content: prompt }],
  });

  try {
    const jsonText = completion.choices[0].message.content.trim();
    console.log("Appliance Guide JSON:", jsonText);
    return JSON.parse(jsonText);
  } catch (err) {
    console.error("⚠️ OpenAI 응답 파싱 오류:", err);
    return {
      advisability: "주의",
      summary: "가전제품 가이드를 생성하는 중 오류가 발생했습니다.",
    };
  }
}