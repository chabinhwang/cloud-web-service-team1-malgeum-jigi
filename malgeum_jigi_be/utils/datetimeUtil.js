// 한국 시간 기준 Date 객체 반환
function getKoreaDate() {
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

// 현재 시각 기준 가장 가까운 과거 정시(00분) 구하기
function getClosestPastHour() {
  const now = getKoreaDate();
  const minutes = now.getMinutes();
  if (minutes === 0) {
    now.setHours(now.getHours() - 1);
  }
  now.setMinutes(0, 0, 0);
  return now;
}

// 현재 날짜 및 시간(YYYYMMDDHHMI) 구하기
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
  const now = getKoreaDate();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");
  return `${year}${month}${day}`;
}