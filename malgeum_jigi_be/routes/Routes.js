import express from "express";
import { getShortForecast, getMidForecast, getDustInfo } from "../services/kmaService.js";
import { generateVentilationScore } from "../services/openaiService.js";

const router = express.Router();

router.get("/air-quality", async (req, res) => {
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({
      success: false,
      code: "INVALID_REQUEST",
      message: "latitude, longitude 파라미터가 필요합니다.",
    });
  }

  try {
    // 1. 단기예보(온도, 습도)
    const shortForecast = await getShortForecast(latitude, longitude);
    const { TA: temperature, HM: humidity } = shortForecast;

    // 2. 황사(PM10)
    const dustInfo = await getDustInfo(latitude, longitude);
    const pm10 = Number(dustInfo?.PM10) || null;

    // 3. 응답 구성
    const response = {
      success: true,
      code: "SUCCESS",
      message: "공기질 데이터 조회 성공",
      data: {
        pm10,
        temperature: Number(temperature),
        humidity: Number(humidity),
      },
      timestamp: new Date().toISOString(),
    };

    res.json(response);
  } catch (error) {
    console.error("air-quality API Error:", error.message);
    res.status(500).json({
      success: false,
      code: "SERVER_ERROR",
      message: "공기질 데이터 조회 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
});

router.get("/ventilation/score", async (req, res) => {
  const { latitude, longitude, location } = req.query;

  if (!latitude || !longitude || !location) {
    return res.status(400).json({
      success: false,
      code: "INVALID_REQUEST",
      message: "latitude, longitude, location 파라미터가 필요합니다.",
    });
  }

  try {
    // 1️⃣ 기상청 단기예보 (온도, 습도, 강수량)
    const forecast = await getShortForecast(latitude, longitude, location);
    const { TA: temperature, HM: humidity, RN: rainfallRaw } = forecast;
    const rainfall = rainfallRaw < 0 ? 0 : rainfallRaw;

    // 2️⃣ 미세먼지 (PM10)
    const dust = await getDustInfo(latitude, longitude, location);
    const pm10 = Number(dust?.PM10) || 0;

    // 3️⃣ OpenAI로 환기 점수 생성
    const aiResult = await generateVentilationScore(temperature, humidity, rainfall, pm10);

    // 4️⃣ 응답 구성
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
    console.error("🚨 /ventilation/score Error:", error.message);
    res.status(500).json({
      success: false,
      code: "SERVER_ERROR",
      message: "환기 점수 조회 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
});

export default router;