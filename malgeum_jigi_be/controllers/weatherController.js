import { getCurrentWeather, getDustInfo, getDailyWeather } from "../services/kmaService.js";
import { connectToDatabase } from "../db/mongoClient.js";
import { getNearestStation } from "../utils/locationUtil.js";

export async function getCurrentAirQuality(req, res) {
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
    // MongoDB 연결
    const { db } = await connectToDatabase();
    const currentCollection = db.collection("current");

    // DB에서 최신 캐시 데이터 조회 (stn 기준으로 최신 1개)
    const cachedData = await currentCollection
      .find(stn ? { stn } : {})
      .sort({ timestamp: -1 })
      .limit(1)
      .toArray();

    if (cachedData.length > 0) {
      const latest = cachedData[0];

      // 🔎 캐시 타임스탬프 가져오기 (updatedAt 우선, 없으면 timestamp)
      const cacheTimeRaw = latest.updatedAt || latest.timestamp;
      const cacheTime = cacheTimeRaw ? new Date(cacheTimeRaw) : null;

      if (cacheTime) {
        const nowKST = getKoreaDate();
        const diffMs = nowKST.getTime() - cacheTime.getTime();
        const THREE_HOURS_MS = 3 * 60 * 60 * 1000;

        // 🕒 3시간 이내인 경우에만 캐시 사용
        if (diffMs >= 0 && diffMs <= THREE_HOURS_MS) {
          console.log("📦 캐시된 current 데이터 반환 (유효, 3시간 이내)");

          return res.json({
            success: true,
            code: "SUCCESS",
            message: "공기질 데이터 조회 성공 (from cache)",
            data: {
              pm10: latest.pm10,
              temperature: latest.temperature,
              humidity: latest.humidity,
            },
            timestamp: cacheTime.toISOString(),
          });
        } else {
          console.log(
            "⏰ 캐시 존재하지만 만료됨 (3시간 초과) → 실시간 API 호출로 전환"
          );
        }
      } else {
        console.log(
          "⚠️ 캐시 문서에 시간 정보(updatedAt/timestamp)가 없음 → 실시간 API 호출"
        );
      }
    } else {
      console.log("📡 캐시 없음 → 실시간 API 호출 중...");
    }


    // 캐시 데이터가 없거나 만료된 경우, 실시간 API 호출
    
    const shortForecast = await getCurrentWeather(latitude, longitude);
    const { TA: temperature, HM: humidity } = shortForecast;

    const dustInfo = await getDustInfo(latitude, longitude);
    const pm10 = Number(dustInfo?.PM10) || null;

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
    // 단기예보(온도, 습도)
    const shortForecast = await getCurrentWeather(latitude, longitude);
    const { TA: temperature, HM: humidity } = shortForecast;

    // 오늘의 일자료 조회 (평균기온, 최고기온, 최저기온, 평균습도)
    const dailyData = await getDailyWeather(latitude, longitude);
    const { TA_MAX, TA_MIN } = dailyData;

    // 데이터 유효성 처리 (음수는 유효 데이터 없음)
    const minTemperature = TA_MIN < 0 ? null : Number(TA_MIN);
    const maxTemperature = TA_MAX < 0 ? null : Number(TA_MAX);

    // 오늘 날짜 (YYYY-MM-DD 형식)
    const today = new Date().toISOString().split("T")[0];
    
    // 응답 구성
    const response = {
      success: true,
      code: "SUCCESS",
      message: "오늘의 환경 데이터 조회 성공",
      data: {
        date: today,
        min_temperature: minTemperature,
        max_temperature: maxTemperature,
        humidity: Number(humidity),
      },
      timestamp: new Date().toISOString(),
    };

    res.json(response);
  } catch (error) {
    console.error("KMA API Error:", error.message);
    res.status(500).json({
      success: false,
      code: "SERVER_ERROR",
      message: "데이터 조회 중 오류가 발생했습니다.",
      error: error.message,
    });
  }
}