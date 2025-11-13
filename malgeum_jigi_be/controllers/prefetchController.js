import { runPrefetch } from "../services/prefetchService.js";

const handlePrefetch = async (req, res) => {
  try {
    console.log("🚀 프리패칭 요청 수신");
    await runPrefetch();
    res.status(200).json({ message: "✅ 프리패칭 완료" });
  } catch (err) {
    console.error("❌ 프리패칭 실패:", err.message);
    res.status(500).json({ error: "프리패칭 중 오류 발생" });
  }
};

export default { handlePrefetch };
