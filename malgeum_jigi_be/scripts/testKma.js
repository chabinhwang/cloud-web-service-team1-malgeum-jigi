import dotenv from "dotenv";
import { getDailyWeather, getDustInfo, getGridXY, getTodayWeather, getWeeklyWeather } from "../services/kmaService.js";

dotenv.config();

async function test() {
  // ✅ 테스트용 입력값 (서울 강남구 근처)
  const lat = 37.4979;
  const lon = 127.0276;
  const address = "서울특별시 강남구";
  const x = 61; // KMA 격자 X 좌표
  const y = 125; // KMA 격자 Y 좌표

  try {
    console.log("📡 단기예보 요청 중...");
    const result = await getWeeklyWeather(x, y);
    console.log("✅ 단기예보 응답 결과:");
    console.log(result);
  } catch (err) {
    console.error("❌ 테스트 실패:", err.message);
  }
}

test();
