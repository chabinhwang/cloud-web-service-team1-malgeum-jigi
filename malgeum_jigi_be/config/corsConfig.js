import cors from "cors";

const allowedOrigins = [
  "http://localhost:50156",      // 개발용 프론트 주소
  "http://malgeum-jigi-web-bucket.s3-website-us-east-1.amazonaws.com" // 배포용 프론트 주소
];

const corsOptions = {
  origin: function (origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error("CORS 정책에 의해 차단됨"));
    }
  },
  credentials: true, // 쿠키/인증정보 포함 허용 시 true
};

export default cors(corsOptions);
