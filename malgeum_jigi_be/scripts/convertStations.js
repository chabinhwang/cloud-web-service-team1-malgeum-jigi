const fs = require('fs');
const path = require('path');

const inputPath = path.join(__dirname, '../data/stations.txt');
const outputPath = path.join(__dirname, '../data/stations.json');

// 파일 읽기
const rawData = fs.readFileSync(inputPath, 'utf8');

// 줄 단위로 분리
const lines = rawData.trim().split('\n');

// 첫 줄이 헤더라면 필요 시 제거 (주석 처리된 경우도 고려)
const dataLines = lines.filter(line => !line.startsWith('#') && line.trim() !== '');

// 각 줄 파싱
const stations = dataLines.map(line => {
  // 공백(또는 탭) 기준으로 분리
  const parts = line.trim().split(/\s+/);

  // 각 열 매핑 (기상청 형식: stn_id, lon, lat, stn_ko)
  return {
    stn_id: Number(parts[0]),
    lon: Number(parts[1]),
    lat: Number(parts[2]),
    stn_ko: parts[10],
  };
});

// JSON 파일로 저장
fs.writeFileSync(outputPath, JSON.stringify(stations, null, 2), 'utf8');

console.log(`✅ 변환 완료: ${stations.length}개의 지점이 stations.json에 저장됨`);
