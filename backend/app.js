const express = require("express");
const bodyParser = require("body-parser");
const connectDB = require("./config/db");
const routes = require("./routes/routes");
const cors = require("cors");
const swaggerUi = require("swagger-ui-express");
const swaggerSpec = require("./swagger/swaggerConfig");

// Load environment variables at the start
require("dotenv").config();

// Connect to MongoDB
connectDB();

const app = express();

app.use(bodyParser.json());

// Allowed origins for CORS (Production + Local Development)
const allowedOrigins = [
  "https://studyspace-platform.vercel.app",
  "http://localhost:8080",
];

// Apply CORS middleware before defining routes
app.use(
  cors({
    origin: function (origin, callback) {
      // Allow requests with no origin (Postman, mobile apps, curl, etc.)
      if (!origin) {
        return callback(null, true);
      }

      if (allowedOrigins.indexOf(origin) !== -1) {
        callback(null, true);
      } else {
        callback(new Error("Not allowed by CORS"));
      }
    },
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
    credentials: true,
  })
);

// Redirect from '/' to '/api-docs
app.get("/", (req, res) => {
  res.redirect("/api-docs");
});

// Define Swagger UI route with custom title
const options = {
  customCss: `
    .swagger-ui .topbar {
      background-color: #3949ab;
    }

    .swagger-ui .topbar-wrapper .link {
      color: white !important;
    }
  `,
  customSiteTitle: "StudySpace API Documentation",
};

// Define Swagger UI route with custom setup
app.use(
  "/api-docs",
  swaggerUi.serve,
  swaggerUi.setup(swaggerSpec, options)
);

// Define routes
app.use("/api", routes);

// Start the server
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});