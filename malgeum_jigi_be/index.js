const express = require('express');
const app = express();
const PORT = 3000;

// 기본 라우트
app.get('/', (req, res) => {
  res.send('Hello, Express!');
});

// 서버 실행
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
