import dotenv from "dotenv";
import { getDailyWeather, getDustInfo } from "../services/kmaService.js";

dotenv.config();

async function test() {
  // ✅ 테스트용 입력값 (서울 강남구 근처)
  const lat = 37.4979;
  const lon = 127.0276;
  const address = "서울특별시 강남구";

  try {
    console.log("📡 일자료 요청 중...");
    const result = await getDailyWeather(lat, lon, address);
    console.log("✅ 일자료 응답 결과:");
    console.log(result);
  } catch (err) {
    console.error("❌ 테스트 실패:", err.message);
  }
}

test();
