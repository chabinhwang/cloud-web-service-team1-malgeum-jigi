import { getCurrentWeather, getDustInfo, getDailyWeather } from "../services/kmaService.js";

export async function getCurrentAirQuality(req, res) {
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({
      success: false,
      code: "INVALID_REQUEST",
      message: "latitude, longitude 파라미터가 필요합니다.",
    });
  }

  try {
    // 1️⃣ 단기예보(온도, 습도)
    const shortForecast = await getCurrentWeather(latitude, longitude);
    const { TA: temperature, HM: humidity } = shortForecast;

    // 2️⃣ 황사(PM10)
    const dustInfo = await getDustInfo(latitude, longitude);
    const pm10 = Number(dustInfo?.PM10) || null;

    // 3️⃣ 응답 구성
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
}

export async function getTodayEnvironment(req, res) {
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({
      success: false,
      code: "INVALID_REQUEST",
      message: "latitude, longitude 파라미터가 필요합니다.",
    });
  }

  try {
    // 오늘의 일자료 조회 (평균기온, 최고기온, 최저기온, 평균습도)
    const dailyData = await getDailyWeather(latitude, longitude);
    const { TA_AVG, TA_MAX, TA_MIN, HM_AVG } = dailyData;

    // 데이터 유효성 처리 (음수는 유효 데이터 없음)
    const avgTemperature = TA_AVG < 0 ? null : Number(TA_AVG);
    const maxTemperature = TA_MAX < 0 ? null : Number(TA_MAX);
    const minTemperature = TA_MIN < 0 ? null : Number(TA_MIN);
    const avgHumidity = HM_AVG < 0 ? null : Number(HM_AVG);

    // 응답 구성
    const response = {
      success: true,
      code: "SUCCESS",
      message: "오늘의 환경 데이터 조회 성공",
      data: {
        avg_temperature: avgTemperature,
        max_temperature: maxTemperature,
        min_temperature: minTemperature,
        avg_humidity: avgHumidity,
      },
      timestamp: new Date().toISOString(),
    };

    res.json(response);
  } catch (error) {
    console.error("daily-weather API Error:", error.message);
    res.status(500).json({
      success: false,
      code: "SERVER_ERROR",
      message: "일자료 데이터 조회 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
}