const serverless = require("serverless-http");

let app;

async function loadApp() {
  if (!app) {
    const imported = await import("./index.js");
    app = imported.default;
  }
  return app;
}

exports.handler = async (event, context) => {
  const appInstance = await loadApp();
  const handler = serverless(appInstance);
  return handler(event, context);
};