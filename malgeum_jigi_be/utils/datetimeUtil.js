
/** 한국 시간 기준 Date 객체 반환 */
export function getKoreaDate() {
  /*
  // 한국 시간으로 현재 시각 문자열 생성
  const nowStr = new Intl.DateTimeFormat("en-US", {
     
    timeZone: "Asia/Seoul", 
     year: "numeric", 
     month: "2-digit", 
     day: "2-digit", 
     hour: "2-digit", 
     minute: "2-digit", 
     second: "2-digit", 
     hour12: false,
     }).format(new Date()); 

     // 문자열을 다시 Date 객체로 변환
    return new Date(nowStr);
  */
  const now = new Date();
  const utcMs = now.getTime() + now.getTimezoneOffset() * 60 * 1000; // 로컬 → UTC
  const koreaMs = utcMs + 9 * 60 * 60 * 1000; // UTC → KST(+9h)
  return new Date(koreaMs);
}

/** 현재 시각 기준 가장 가까운 과거 정시(00분) 반환 */
export function getClosestPastHour() {
  const now = getKoreaDate();
  const minutes = now.getMinutes();
  if (minutes === 0) now.setHours(now.getHours() - 1);
  now.setMinutes(0, 0, 0);
  return now;
}

/** 날짜 포맷: YYYYMMDDHHMI */
export function formatDateToKmaTm(date) {
  const YYYY = date.getFullYear();
  const MM = String(date.getMonth() + 1).padStart(2, "0");
  const DD = String(date.getDate()).padStart(2, "0");
  const HH = String(date.getHours()).padStart(2, "0");
  const MI = String(date.getMinutes()).padStart(2, "0");
  return `${YYYY}${MM}${DD}${HH}${MI}`;
}

/** 오늘 날짜 YYYYMMDD */
export function getTodayDateString() {
  const now = getKoreaDate();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");
  return `${year}${month}${day}`;
}

/** 오늘 기준 n일 후 날짜 (YYYYMMDD) */
export function getFutureDateStrings(days) {
  const today = getKoreaDate();
  return Array.from({ length: days }, (_, i) => {
    const d = new Date(today);
    d.setDate(today.getDate() + i);
    return d.toISOString().slice(0, 10).replace(/-/g, "");
  });
}

/** 05:00 기준 보정된 날짜 */
export function getAdjustedBaseDate() {
  const now = getKoreaDate();
  const hour = now.getHours();

  // 오늘 날짜 기본값
  let baseDate = getTodayDateString();

  // 한국시간 05:00 이전 → 어제 날짜 사용
  if (hour < 5) {
    const yesterday = new Date(now);
    yesterday.setDate(yesterday.getDate() - 1);

    const y = yesterday.getFullYear();
    const m = String(yesterday.getMonth() + 1).padStart(2, "0");
    const d = String(yesterday.getDate()).padStart(2, "0");

    baseDate = `${y}${m}${d}`;
  }
  return baseDate;
}
