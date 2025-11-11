
/** 한국 시간 기준 Date 객체 반환 */
export function getKoreaDate() {
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
