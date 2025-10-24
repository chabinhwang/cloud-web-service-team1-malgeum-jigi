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
