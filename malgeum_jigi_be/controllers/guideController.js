import e from "express";
import { getShortForecast, getMidForecast, getDustInfo } from "../services/kmaService.js";
import { generateVentilationScore, generateOutdoorGuide } from "../services/openaiService.js";

export async function getVentilationScore(req, res) {
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
}