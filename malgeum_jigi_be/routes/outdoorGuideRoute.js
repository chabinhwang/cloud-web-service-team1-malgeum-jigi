import express from "express";
import { getShortForecast, getDustInfo } from "../services/kmaService.js";
import { generateOutdoorGuide } from "../services/openaiService.js";

const router = express.Router();

/**
 * GET /outdoor-guide
 * latitude, longitude 쿼리 파라미터 필요
 */
router.get("/outdoor-guide", async (req, res) => {
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({
      success: false,
      code: "INVALID_REQUEST",
      message: "latitude, longitude 파라미터가 필요합니다.",
    });
  }

  try {
    // 1️⃣ 기상청 단기예보
    const forecast = await getShortForecast(latitude, longitude, "현재 위치");
    const { TA: temperature, HM: humidity, RN: rainfallRaw } = forecast;
    const rainfall = rainfallRaw < 0 ? 0 : rainfallRaw;

    // 2️⃣ 황사 (PM10)
    const dust = await getDustInfo(latitude, longitude, "현재 위치");
    const pm10 = Number(dust?.PM10) || 0;

    // 3️⃣ OpenAI로 외출 가이드 생성
    const aiResult = await generateOutdoorGuide(temperature, humidity, rainfall, pm10);

    // 4️⃣ 응답 구성
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
    console.error("🚨 /outdoor-guide Error:", error.message);
    res.status(500).json({
      success: false,
      code: "SERVER_ERROR",
      message: "외출 가이드 조회 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
});

export default router;
