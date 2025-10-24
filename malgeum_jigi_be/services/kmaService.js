import axios from "axios";
import dotenv from "dotenv";
dotenv.config();

const KMA_KEY = process.env.KMA_KEY;

// 단기예보
export async function getShortForecast(lat, lon, address) {
  const url = `https://apihub.kma.go.kr/api/typ01/url/kma_sfctm2.php?stn=0&authKey=${KMA_KEY}`;
  const response = await axios.get(url);
  return response.data;
}

// 중기예보
export async function getMidForecast(lat, lon, address) {
  const url = `https://apihub.kma.go.kr/api/typ01/url/kma_midtm2.php?stn=0&authKey=${KMA_KEY}`;
  const response = await axios.get(url);
  return response.data;
}

// 황사 정보
export async function getDustInfo() {
  const url = `https://apihub.kma.go.kr/api/typ01/url/kma_dust.php?authKey=${KMA_KEY}`;
  const response = await axios.get(url);
  return response.data;
}
