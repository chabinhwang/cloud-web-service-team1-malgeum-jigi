import axios from "axios";
import dotenv from "dotenv";
import { getNearestStation } from "../utils/locationUtil.js";
import {
  getClosestPastHour,
  formatDateToKmaTm,
  getTodayDateString,
  getFutureDateStrings,
} from "../utils/datetimeUtil.js";

dotenv.config();
const KMA_KEY = process.env.KMA_KEY;

// ✅ 공통 요청 함수
async function fetchKmaData(url, params, description) {
  try {
    const response = await axios.get(url, params ? { params } : undefined);
    const fullUrl = params ? `${url}?${new URLSearchParams(params).toString()}` : url;

    // 요청 성공 로그
    console.log(`✅ [KMA 응답 성공] ${description}`);
    console.log(`🔗 ${fullUrl}`);

    return response.data;
  } catch (error) {
    const fullUrl = params ? `${url}?${new URLSearchParams(params).toString()}` : url;

    // 요청 실패 로그
    console.error(`❌ [KMA 요청 실패] ${description}`);
    console.error(`🔗 ${fullUrl}`);
    console.error(`🧩 오류: ${error.message}`);

    throw new Error(`${description} 실패`);
  }
}

// ✅ 단기예보 공통 함수
async function getForecastData(x, y, filterFn, description) {
  const baseDate = getTodayDateString();
  const url = `https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/getVilageFcst`;
  const params = {
    pageNo: 1,
    numOfRows: 1000,
    dataType: "JSON",
    base_date: baseDate,
    base_time: "0500",
    nx: x,
    ny: y,
    authKey: KMA_KEY,
  };

  const data = await fetchKmaData(url, params, description);
  const items = data?.response?.body?.items?.item;

  if (!items) throw new Error("응답 데이터에 item이 없습니다.");

  const filtered = items.filter(filterFn).map(({ category, fcstDate, fcstTime, fcstValue }) => ({
    category,
    fcstDate,
    fcstTime,
    fcstValue,
  }));

  return filtered;
}

// ✅ 현재 기상 정보
export async function getCurrentWeather(lat, lon, address) {
  try {
    const stn = await getNearestStation(lat, lon, address);
    const tm = formatDateToKmaTm(getClosestPastHour());
    const url = `https://apihub.kma.go.kr/api/typ01/url/kma_sfctm2.php?tm=${tm}&stn=${stn}&help=0&authKey=${KMA_KEY}`;

    const data = await fetchKmaData(url, null, "현재 기상 조회");

    const lines = data.trim().split("\n");
    const lastLine = lines.find((line) => /^\d{12}/.test(line));
    if (!lastLine) throw new Error("데이터 줄을 찾을 수 없습니다.");

    const parts = lastLine.trim().split(/\s+/);
    const WS = parseFloat(parts[3]);
    const TA = parseFloat(parts[11]);
    const HM = parseFloat(parts[13]);
    const RN = parseFloat(parts[15]);

    return { stn, tm, WS, TA, HM, RN };
  } catch (err) {
    console.error("❌ 현재 기상 정보 조회 실패:", err.message);
    throw err;
  }
}

// ✅ PM10(황사) 정보
export async function getDustInfo(lat, lon, address) {
  try {
    const stn = await getNearestStation(lat, lon, address);
    const tm = formatDateToKmaTm(getClosestPastHour());
    const url = `https://apihub.kma.go.kr/api/typ01/url/kma_pm10.php?tm1=${tm}&tm2=${tm}&stn=108&authKey=${KMA_KEY}`;

    const data = await fetchKmaData(url, null, "PM10 조회");

    const lines = data.trim().split("\n");
    const lastLine = lines.find((line) => /^\d{12}/.test(line));
    if (!lastLine) throw new Error("데이터 줄을 찾을 수 없습니다.");

    const parts = lastLine.trim().split(/\s+/);
    const PM10 = parseFloat(parts[2]);

    return { stn, tm, PM10 };
  } catch (err) {
    console.error("❌ PM10 조회 실패:", err.message);
    throw err;
  }
}

// ✅ 일자료
export async function getDailyWeather(lat, lon, address) {
  try {
    const stn = await getNearestStation(lat, lon, address);
    const tm = getTodayDateString();
    const url = `https://apihub.kma.go.kr/api/typ01/url/kma_sfcdd.php?tm=${tm}&stn=${stn}&help=0&authKey=${KMA_KEY}`;

    const data = await fetchKmaData(url, null, "일자료 조회");

    const lines = data.trim().split("\n");
    const lastLine = lines.find((line) => /^\d{8}/.test(line));
    if (!lastLine) throw new Error("데이터 줄을 찾을 수 없습니다.");

    const parts = lastLine.trim().split(",");
    const TA_AVG = parseFloat(parts[10]);
    const TA_MAX = parseFloat(parts[11]);
    const TA_MIN = parseFloat(parts[13]);
    const HM_AVG = parseFloat(parts[18]);

    return { stn, tm, TA_AVG, TA_MAX, TA_MIN, HM_AVG };
  } catch (err) {
    console.error("❌ 일자료 조회 실패:", err.message);
    throw err;
  }
}

// ✅ 격자 변환
export async function getGridXY(lat, lon) {
  const url = `https://apihub.kma.go.kr/api/typ01/cgi-bin/url/nph-dfs_xy_lonlat?lon=${lon}&lat=${lat}&help=0&authKey=${KMA_KEY}`;
  const data = await fetchKmaData(url, null, "격자 변환");

  const lines = data.trim().split("\n");
  const lastLine = lines[lines.length - 1].trim();
  const parts = lastLine.split(",").map((v) => v.trim());

  return { x: parseInt(parts[2]), y: parseInt(parts[3]) };
}

// ✅ 오늘 날씨
export async function getTodayWeather(x, y) {
  const baseDate = getTodayDateString();
  return getForecastData(
    x,
    y,
    (it) => it.fcstDate === baseDate && (it.category === "TMP" || it.category === "REH"),
    "오늘 단기예보 조회"
  );
}

// ✅ 주간 날씨
export async function getWeeklyWeather(x, y) {
  const targetDates = getFutureDateStrings(4);
  return getForecastData(
    x,
    y,
    (it) =>
      targetDates.includes(it.fcstDate) &&
      ["TMP", "SKY", "PTY", "POP", "REH"].includes(it.category),
    "주간 단기예보 조회"
  );
}
