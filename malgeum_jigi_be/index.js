import express from "express";
import dotenv from "dotenv";
import routes from "./routes/Routes.js";
import outdoorGuideRoute from "./routes/outdoorGuideRoute.js";

dotenv.config(); // .env 파일 로드

const app = express();
const PORT = process.env.PORT || 3000;

// 미들웨어 설정
app.use(express.json()); // JSON 요청 바디 파싱

// 라우트 등록
app.use("/", routes);
app.use("/", outdoorGuideRoute);

// 기본 라우트
app.get("/", (req, res) => {
  res.send("🌤️ 스마트 환기 & 생활환경 가이드 서버가 실행 중입니다.");
});

// 서버 시작
app.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
});
