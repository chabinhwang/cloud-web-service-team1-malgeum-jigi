import axios from "axios";
import dotenv from "dotenv";
import { getNearestStation } from "../utils/locationUtil.js";

dotenv.config();
const KMA_KEY = process.env.KMA_KEY;

// 현재 시각 기준, 가장 가까운 과거 정시(00분) 구하기
function getClosestPastHour() {
  const now = new Date();
  const minutes = now.getMinutes();

  if (minutes === 0) {
    // 00분이면 1시간 전으로
    now.setHours(now.getHours() - 1);
  }
  now.setMinutes(0, 0, 0); // 분, 초, 밀리초를 0으로
  return now;
}

// Date 객체 → YYYYMMDDHHMI (예: 202510241700)
function formatDateToKmaTm(date) {
  const YYYY = date.getFullYear();
  const MM = String(date.getMonth() + 1).padStart(2, "0");
  const DD = String(date.getDate()).padStart(2, "0");
  const HH = String(date.getHours()).padStart(2, "0");
  const MI = String(date.getMinutes()).padStart(2, "0");
  return `${YYYY}${MM}${DD}${HH}${MI}`;
}

// 오늘 날짜(YYYYMMDD) 구하기
function getTodayDateString() {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");
  return `${year}${month}${day}`;
}

// 현재 기상 정보
export async function getCurrentWeather(lat, lon, address) {
  try {
    // 1️⃣ 위경도 → 기상청 지점번호(stn)
    const stn = await getNearestStation(lat, lon, address);

    // 2️⃣ tm 파라미터: 가장 가까운 과거 정시
    const tm = formatDateToKmaTm(getClosestPastHour());

    // 3️⃣ 요청 URL 구성
    const url = `https://apihub.kma.go.kr/api/typ01/url/kma_sfctm2.php?tm=${tm}&stn=${stn}&help=0&authKey=${KMA_KEY}`;

    // 4️⃣ API 요청
    const response = await axios.get(url);
    const data = response.data;

    // 5️⃣ 응답 파싱: 마지막 데이터 줄만 추출
    const lines = data.trim().split("\n");
    const lastLine = lines.find((line) => /^\d{12}/.test(line)); // YYMMDDHHMI로 시작하는 실제 데이터 줄

    if (!lastLine) {
      throw new Error("기상청 응답에서 데이터 줄을 찾을 수 없습니다.");
    }

    // 6️⃣ 공백 기준 분리
    const parts = lastLine.trim().split(/\s+/);

    // KMA 응답 포맷 기준:
    // WS(풍속) = 4번째, TA(기온) = 12번째, HM(습도) = 14번째, RN(강수량) = 16번째
    const WS = parseFloat(parts[3]);
    const TA = parseFloat(parts[11]);
    const HM = parseFloat(parts[13]);
    const RN = parseFloat(parts[15]);

    // 7️⃣ 필요한 값만 반환
    return { stn, tm, WS, TA, HM, RN };
  } catch (err) {
    console.error("❌ 단기예보 조회 실패:", err.message);
    throw new Error("단기예보 조회 실패");
  }
}

// 황사 정보
export async function getDustInfo(lat, lon, address) {
    try {
    // 1️⃣ 위경도 → 기상청 지점번호(stn)
    const stn = await getNearestStation(lat, lon, address);

    // 2️⃣ tm 파라미터: 가장 가까운 과거 정시
    const tm = formatDateToKmaTm(getClosestPastHour());

    // 3️⃣ 요청 URL 구성
    const url = `https://apihub.kma.go.kr/api/typ01/url/kma_pm10.php?tm1=${tm}&tm2=${tm}&stn=108&authKey=${KMA_KEY}`;

    // 4️⃣ API 요청
    const response = await axios.get(url);
    const data = response.data;

    // 5️⃣ 응답 파싱: 마지막 데이터 줄만 추출
    const lines = data.trim().split("\n");
    const lastLine = lines.find((line) => /^\d{12}/.test(line)); // YYMMDDHHMI로 시작하는 실제 데이터 줄

    if (!lastLine) {
      throw new Error("기상청 응답에서 데이터 줄을 찾을 수 없습니다.");
    }

    // 6️⃣ 공백 기준 분리
    const parts = lastLine.trim().split(/\s+/);

    // KMA 응답 포맷에 따른 값 추출
    const PM10 = parseFloat(parts[2]);

    // 7️⃣ 필요한 값만 반환
    return { stn, tm, PM10 };
  } catch (err) {
    console.error("❌ PM10 조회 실패:", err.message);
    throw new Error("PM10 조회 실패");
  }
}

// 일자료
export async function getDailyWeather(lat, lon, address) {
    try {
    // 1️⃣ 위경도 → 기상청 지점번호(stn)
    const stn = await getNearestStation(lat, lon, address);

    // 2️⃣ tm 파라미터: 가장 가까운 과거 정시
    const tm = getTodayDateString();

    // 3️⃣ 요청 URL 구성
    const url = `https://apihub.kma.go.kr/api/typ01/url/kma_sfcdd.php?tm=${tm}&stn=${stn}&help=0&authKey=${KMA_KEY}`;

    // 4️⃣ API 요청
    const response = await axios.get(url);
    const data = response.data;

    // 5️⃣ 응답 파싱: 마지막 데이터 줄만 추출
    const lines = data.trim().split("\n");
    const lastLine = lines.find((line) => /^\d{8}/.test(line)); // YYMMDD로 시작하는 실제 데이터 줄

    if (!lastLine) {
      throw new Error("기상청 응답에서 데이터 줄을 찾을 수 없습니다.");
    }

    // 6️⃣ 쉼표(,) 기준 분리
    const parts = lastLine.trim().split(",");

    // KMA 응답 포맷에 따른 값 추출
    const TA_AVG = parseFloat(parts[10]);
    const TA_MAX = parseFloat(parts[11]);
    const TA_MIN = parseFloat(parts[13]);
    const HM_AVG = parseFloat(parts[18]);

    // 7️⃣ 필요한 값만 반환
    return { stn, tm, TA_AVG, TA_MAX, TA_MIN, HM_AVG };
  } catch (err) {
    console.error("❌ 일자료 조회 실패:", err.message);
    throw new Error("일자료 조회 실패");
  }
}

