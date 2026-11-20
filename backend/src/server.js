require("dotenv").config();

const express = require("express");
const cors = require("cors");

const app = express();

const allowedOrigins = [
  "https://studyspace-platform.vercel.app",
  "http://localhost:8080",
];

// 1) Manual CORS: answers preflight immediately
app.use((req, res, next) => {
  const origin = req.headers.origin;
  if (origin && allowedOrigins.includes(origin)) {
    res.setHeader("Access-Control-Allow-Origin", origin);
    res.setHeader("Vary", "Origin");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,POST,PUT,PATCH,DELETE,OPTIONS");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
  }
  if (req.method === "OPTIONS") return res.status(204).end();
  next();
});

app.use(
  cors({
    origin: (origin, cb) => cb(null, !origin || allowedOrigins.includes(origin)),
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
    credentials: true,
  })
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 2) Load modules safely so a crash shows a readable error
let connectDB, routes, swaggerSpec;
const loadErrors = [];

try { connectDB = require("../config/db"); } catch (e) { loadErrors.push("db: " + e.message); }
try { routes = require("../routes/routes"); } catch (e) { loadErrors.push("routes: " + e.message); }
try { swaggerSpec = require("../swagger/swaggerConfig"); } catch (e) { loadErrors.push("swagger: " + e.message); }

// 3) Routes that don't need the database
app.get("/health", (req, res) =>
  res.json({ status: "ok", version: "final-v7", loadErrors })
);

app.get("/swagger.json", (req, res) => {
  if (!swaggerSpec) return res.status(500).json({ error: "Swagger spec failed to load" });
  res.json(swaggerSpec);
});

app.get("/api-docs", (req, res) => {
  res.type("html").send(`<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>StudySpace API Documentation</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5.17.14/swagger-ui.css" />
  <style>.swagger-ui .topbar { background-color: #3949ab; }</style>
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist@5.17.14/swagger-ui-bundle.js"></script>
  <script>
    window.onload = () => {
      window.ui = SwaggerUIBundle({ url: "/swagger.json", dom_id: "#swagger-ui" });
    };
  </script>
</body>
</html>`);
});

app.get("/", (req, res) => res.redirect("/api-docs"));

// 4) If routes or db failed to load, show why
app.use((req, res, next) => {
  if (!connectDB || !routes) {
    return res.status(500).json({ success: false, loadErrors });
  }
  next();
});

// 5) Connect DB per request (cached)
app.use(async (req, res, next) => {
  try {
    await connectDB();
    next();
  } catch (err) {
    console.error("DB connection failed:", err);
    res.status(500).json({
      success: false,
      message: "Database connection failed",
      error: err.message,
    });
  }
});

// 6) API routes
app.use("/api", routes);

// 7) Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, message: err.message });
});

process.on("unhandledRejection", (err) => console.error("Unhandled rejection:", err));
process.on("uncaughtException", (err) => console.error("Uncaught exception:", err));

// No app.listen here. local-dev.js does that locally, Vercel uses the export.
module.exports = app;