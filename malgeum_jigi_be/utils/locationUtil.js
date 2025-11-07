import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

// 절대 경로 기준 JSON 파일 로드
const stationsPath = path.join(process.cwd(), "data", "stations.json");
const stations = JSON.parse(fs.readFileSync(stationsPath, "utf8"));

// JSON 파일 로드
//const stationsPath = path.resolve("data", "stations.json");
//const stations = JSON.parse(fs.readFileSync(stationsPath, "utf8"));

// 위경도 거리 계산 (단순 유클리드 거리)
function getDistance(lat1, lon1, lat2, lon2) {
  return Math.sqrt((lat1 - lat2) ** 2 + (lon1 - lon2) ** 2);
}

export function getNearestStation(lat, lon, address) {
  let nearest = null;
  let minDist = Infinity;

  for (const s of stations) {
    const dist = getDistance(lat, lon, s.lat, s.lon);
    if (dist < minDist) {
      minDist = dist;
      nearest = s;
    }
  }

  return nearest ? nearest.stn_id : 0; // 못 찾으면 기본값 0
}
