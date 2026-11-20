require("dotenv").config();

const express = require("express");
const cors = require("cors");

const app = express();

const allowedOrigins = [
  "https://studyspace-platform.vercel.app",
  "http://localhost:8080",
];

// 1) Manual CORS: answers preflight immediately, before anything can crash
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

// 2) Load modules safely so a crash shows a readable error instead of a 500 page
let connectDB, routes, swaggerSpec, swaggerUi;
const loadErrors = [];

try { connectDB = require("../config/db"); } catch (e) { loadErrors.push("db: " + e.message); }
try { routes = require("../routes/routes"); } catch (e) { loadErrors.push("routes: " + e.message); }
try {
  swaggerSpec = require("../swagger/swaggerConfig");
  swaggerUi = require("swagger-ui-express");
} catch (e) { loadErrors.push("swagger: " + e.message); }

// 3) Health check (no DB needed)
app.get("/health", (req, res) =>
  res.json({ status: "ok", version: "final-v5", loadErrors })
);

// 4) If any module failed to load, show why
app.use((req, res, next) => {
  if (loadErrors.length) return res.status(500).json({ success: false, loadErrors });
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

app.get("/", (req, res) => res.redirect("/api-docs"));

if (swaggerUi && swaggerSpec) {
  app.use(
    "/api-docs",
    swaggerUi.serve,
    swaggerUi.setup(swaggerSpec, {
      customCss: `
        .swagger-ui .topbar { background-color: #3949ab; }
        .swagger-ui .topbar-wrapper .link { color: white !important; }
      `,
      customSiteTitle: "StudySpace API Documentation",
    })
  );
  app.get("/swagger.json", (req, res) => res.json(swaggerSpec));
}

app.use("/api", routes);

// 6) Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, message: err.message });
});

process.on("unhandledRejection", (err) => console.error("Unhandled rejection:", err));
process.on("uncaughtException", (err) => console.error("Uncaught exception:", err));

// No app.listen here. local-dev.js does that locally, Vercel uses the export.
module.exports = app;