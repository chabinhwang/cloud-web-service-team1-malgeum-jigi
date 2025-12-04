import { getCurrentWeather, getDustInfo, getGridXY, getTodayWeather, getWeeklyWeather } from "../services/kmaService.js";
import { generateVentilationScore, generateOutdoorGuide, generateApplianceGuide, generateWeeklyGuide } from "../services/openaiService.js";
import { connectToDatabase } from "../db/mongoClient.js";
import { getNearestStation } from "../utils/locationUtil.js";

export async function getVentilationScore(req, res) {
  const { latitude, longitude, location_name } = req.query;
  const location = location_name || "현재 위치";

  if (!latitude || !longitude) {
    return res.status(400).json({
      success: false,
      code: "INVALID_REQUEST",
      message: "latitude, longitude 파라미터가 필요합니다.",
    });
  }

  // 가장 가까운 기상 관측소 찾기
  const stn = await getNearestStation(latitude, longitude, "");

  try {
    const { db } = await connectToDatabase();
    const ventilationCol = db.collection("ventilation");

    const cached = await ventilationCol.find({ stn }).sort({ timestamp: -1 }).limit(1).toArray();

    if (cached.length > 0) {
    const latest = cached[0];

    // updatedAt 우선, 없으면 timestamp 사용
    const cacheTimeRaw = latest.updatedAt || latest.timestamp;
    const cacheTime = cacheTimeRaw ? new Date(cacheTimeRaw) : null;

    if (cacheTime) {
      const now = new Date(); // 서버 환경(로컬/람다/us-east) 상관 없이 UTC 기준 ms로 비교
      const diffMs = now.getTime() - cacheTime.getTime();
      const THREE_HOURS_MS = 3 * 60 * 60 * 1000;

      if (diffMs >= 0 && diffMs <= THREE_HOURS_MS) {
        console.log(`📦 환기 점수 캐시 사용 (${stn}) - 3시간 이내`);

        return res.json({
          success: true,
          code: "SUCCESS",
          message: "환기 점수 조회 성공 (from cache)",
          data: {
            score: latest.score,
            status: latest.status,
            emoji: latest.emoji,
            location: latest.location || location,
            description: latest.description,
          },
          timestamp: cacheTime.toISOString(),
        });
      } else {
        console.log(
          `⏰ 환기 점수 캐시 만료 (${stn}) - 마지막 갱신 후 3시간 초과, 실시간 생성으로 진행`
        );
      }
    } else {
      console.log(
        `⚠️ 환기 점수 캐시에 시간 정보(updatedAt/timestamp) 없음 (${stn}) → 실시간 생성`
      );
    }
  } else {
    console.log(`📡 환기 점수 캐시 없음 (${stn}) → 실시간 생성`);
  }


    // 캐시 데이터가 없을 경우

    // 기상청 단기예보 (온도, 습도, 강수량)
    const forecast = await getCurrentWeather(latitude, longitude, location);
    const { TA: temperature, HM: humidity, RN: rainfallRaw } = forecast;
    const rainfall = rainfallRaw < 0 ? 0 : rainfallRaw;

    // 미세먼지 (PM10)
    const dust = await getDustInfo(latitude, longitude, location);
    const pm10 = Number(dust?.PM10) || 0;

    // OpenAI로 환기 점수 생성
    const aiResult = await generateVentilationScore(temperature, humidity, rainfall, pm10);

    // 응답 구성
    const response = {
      success: true,
      code: "SUCCESS",
      message: "환기 점수 조회 성공",
      data: {
        score: aiResult.score,
        status: aiResult.status,
        emoji: aiResult.emoji,
        location: location,
        description: aiResult.description,
      },
      timestamp: new Date().toISOString(),
    };
    res.json(response);

  } catch (error) {
    console.error("🚨 /api/guides/ventilation Error:", error.message);
    res.status(500).json({
      success: false,
      code: "SERVER_ERROR",
      message: "환기 점수 조회 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
}

export async function getOutdoorGuide(req, res) {
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({
      success: false,
      code: "INVALID_REQUEST",
      message: "latitude, longitude 파라미터가 필요합니다.",
    });
  }

  // 가장 가까운 기상 관측소 찾기
  const stn = await getNearestStation(latitude, longitude, "");

  try {
    const { db } = await connectToDatabase();
    const outdoorCol = db.collection("outdoor");

    const cached = await outdoorCol.find({ stn }).sort({ timestamp: -1 }).limit(1).toArray();

    if (cached.length > 0) {
    const latest = cached[0];

    // updatedAt 우선 사용
    const cacheTimeRaw = latest.updatedAt || latest.timestamp;
    const cacheTime = cacheTimeRaw ? new Date(cacheTimeRaw) : null;

    if (cacheTime) {
      const now = new Date();
      const diffMs = now.getTime() - cacheTime.getTime();
      const THREE_HOURS_MS = 3 * 60 * 60 * 1000;

      if (diffMs >= 0 && diffMs <= THREE_HOURS_MS) {
        console.log(`📦 외출 가이드 캐시 사용 (${stn}) - 3시간 이내`);

        return res.json({
          success: true,
          code: "SUCCESS",
          message: "외출 가이드 조회 성공 (from cache)",
          data: {
            advisability: latest.advisability,
            summary: latest.summary,
            recommendations: latest.recommendations,
          },
          timestamp: cacheTime.toISOString(),
        });
      } else {
        console.log(
          `⏰ 외출 가이드 캐시 만료 (${stn}) - 마지막 갱신 후 3시간 초과`
        );
      }
    } else {
      console.log(
        `⚠️ 외출 가이드 캐시 시간 정보 없음 (${stn}) → 실시간 생성`
      );
    }
  } else {
    console.log(`📡 외출 가이드 캐시 없음 (${stn}) → 실시간 생성`);
  }

    // 기상청 단기예보
    const forecast = await getCurrentWeather(latitude, longitude, "현재 위치");
    const { TA: temperature, HM: humidity, RN: rainfallRaw } = forecast;
    const rainfall = rainfallRaw < 0 ? 0 : rainfallRaw;

    // 황사 (PM10)
    const dust = await getDustInfo(latitude, longitude, "현재 위치");
    const pm10 = Number(dust?.PM10) || 0;

    // OpenAI로 외출 가이드 생성
    const aiResult = await generateOutdoorGuide(temperature, humidity, rainfall, pm10);

    // 응답 구성
    const response = {
      success: true,
      code: "SUCCESS",
      message: "외출 가이드 조회 성공",
      data: {
        advisability: aiResult.advisability,
        summary: aiResult.summary,
        recommendations: aiResult.recommendations,
      },
      timestamp: new Date().toISOString(),
    };
    res.json(response);

  } catch (error) {
    console.error("🚨 /api/guides/outdoor Error:", error.message);
    res.status(500).json({
      success: false,
      code: "SERVER_ERROR",
      message: "외출 가이드 조회 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
}

export async function getApplianceGuide(req, res) {
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({
      success: false,
      code: "INVALID_REQUEST",
      message: "latitude, longitude 파라미터가 필요합니다.",
    });
  }

  try {
    // 위경도 → 격자좌표 변환
    const { x, y } = await getGridXY(latitude, longitude);

    // 단기예보로 오늘의 시간별 온습도 조회
    const weatherData = await getTodayWeather(x, y);

    // OpenAI로 가전제품 사용 가이드 생성
    const applianceGuide = await generateApplianceGuide(weatherData);

    // 최종 응답
    res.json({
      success: true,
      code: "SUCCESS",
      message: "가전제품 사용 가이드 조회 성공",
      data: { appliances: applianceGuide },
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error("getApplianceGuide Error:", error.message);
    res.status(500).json({
      success: false,
      code: "SERVER_ERROR",
      message: "가전제품 가이드 생성 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
}

export async function getWeeklyGuide(req, res) {
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({
      success: false,
      code: "INVALID_REQUEST",
      message: "latitude, longitude 파라미터가 필요합니다.",
    });
  }

  try {
    // 위경도 → 격자좌표 변환
    const { x, y } = await getGridXY(latitude, longitude);

    // 단기예보로 주간 날씨 조회
    const weatherData = await getWeeklyWeather(x, y);

    // OpenAI로 주간 생활 가이드 생성
    const weeklyGuide = await generateWeeklyGuide(weatherData);

    // 최종 응답
    res.json({
      success: true,
      code: "SUCCESS",
      message: "주간 생활 가이드 조회 성공",
      data: weeklyGuide,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error("getApplianceGuide Error:", error.message);
    res.status(500).json({
      success: false,
      code: "SERVER_ERROR",
      message: "주간 생활 가이드 생성 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
}