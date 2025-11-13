import { MongoClient } from "mongodb";
import dotenv from "dotenv";

dotenv.config();

const MONGO_URI = process.env.MONGO_URI;
const DB_NAME = process.env.DB_NAME || "malgeum_jigi_db";

if (!MONGO_URI) {
  throw new Error("❌ MONGO_URI is not defined in environment variables.");
}

// 전역(모듈) 스코프에 클라이언트 캐싱
let cachedClient = null;
let cachedDb = null;

/**
 * MongoDB 연결을 관리하고, 이미 연결된 경우 캐시된 인스턴스를 반환합니다.
 * 서버리스 환경(Lambda)에서도 재사용이 가능하도록 설계됨.
 */
export async function connectToDatabase() {
  if (cachedClient && cachedDb) {
    return { client: cachedClient, db: cachedDb };
  }

  try {
    console.log("📡 Connecting to MongoDB...");

    const client = new MongoClient(MONGO_URI, {
      maxPoolSize: 10,
      serverSelectionTimeoutMS: 15000,
    });

    await client.connect();

    const db = client.db(DB_NAME);
    cachedClient = client;
    cachedDb = db;

    console.log("✅ MongoDB connected successfully.");
    return { client, db };
  } catch (err) {
    console.error("❌ MongoDB connection failed:", err);
    throw err;
  }
}
