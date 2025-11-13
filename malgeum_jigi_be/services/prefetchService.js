import { getCurrentWeather, getDustInfo } from "../services/kmaService.js";
import { generateVentilationScore, generateOutdoorGuide } from "../services/openaiService.js";
import { connectToDatabase } from "../db/mongoClient.js";

const STN_LIST = [
    { "stn_id": 108, "lon": 126.9658, "lat": 37.57142, "stn_ko": "서울" },
    { "stn_id": 112, "lon": 126.6249, "lat": 37.47772, "stn_ko": "인천" },
    { "stn_id": 119, "lon": 126.983, "lat": 37.25746, "stn_ko": "수원" },
];

/**
 * 각 컬렉션에 프리패칭 데이터를 개별로 저장
 * current / ventilation / outdoor
 */
export async function runPrefetch() {
  const { db } = await connectToDatabase();
  console.log("🔄 프리패칭 시작...");

  for (const loc of STN_LIST) {
    try {
      // ✅ 1. 기상 및 미세먼지 데이터 가져오기
      const { stn, TA, HM, RN } = await getCurrentWeather(loc.lat, loc.lon, loc.stn_ko);
      const dust = await getDustInfo(loc.lat, loc.lon);
      const pm10 = Number(dust?.PM10) || 0;

      // ✅ 2. current 데이터 저장
      await db.collection("current").updateOne(
        { stn },
        {
          $set: {
            stn,
            pm10,
            temperature: TA,
            humidity: HM,
            updatedAt: new Date(),
          },
        },
        { upsert: true }
      );

      // ✅ 3. ventilation 데이터 저장
      const ventilation = await generateVentilationScore(TA, HM, RN, pm10);
      await db.collection("ventilation").updateOne(
        { stn },
        { $set: { stn, ...ventilation, updatedAt: new Date() } },
        { upsert: true }
      );

      // ✅ 4. outdoor 데이터 저장
      const outdoor = await generateOutdoorGuide(TA, HM, RN, pm10);
      await db.collection("outdoor").updateOne(
        { stn },
        { $set: { stn, ...outdoor, updatedAt: new Date() } },
        { upsert: true }
      );

      console.log(`✅ 프리패칭 완료: ${loc.stn_ko} (${stn})`);
    } catch (err) {
      console.error(`❌ 프리패칭 실패 (${loc.stn_ko}):`, err.message);
    }
  }

  console.log("🏁 모든 지역 프리패칭 완료");
}
