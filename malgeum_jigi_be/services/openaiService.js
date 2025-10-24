import axios from "axios";
import dotenv from "dotenv";
dotenv.config();

const OPENAI_KEY = process.env.OPENAI_KEY;

export async function generateGuide(prompt) {
  const url = "https://api.openai.com/v1/chat/completions";
  const headers = {
    Authorization: `Bearer ${OPENAI_KEY}`,
    "Content-Type": "application/json",
  };

  const body = {
    model: "gpt-4o-mini",
    messages: [{ role: "user", content: prompt }],
  };

  const response = await axios.post(url, body, { headers });
  return response.data.choices[0].message.content;
}
