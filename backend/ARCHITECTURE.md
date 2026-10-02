# 🏗️ StudySpace Backend Architecture

## 📊 System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Frontend (Vue.js)                       │
│                    https://studysync.vercel.app                 │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 │ HTTPS/REST API
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Vercel Edge Network                        │
│                    (CDN + Serverless Functions)                 │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                       Express.js Backend                        │
│                        (src/server.js)                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Routes Layer                                             │  │
│  │  /api/auth, /api/materials, /api/quizzes, etc.            │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                │                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Middleware Layer                                         │  │
│  │  - CORS                                                   │  │
│  │  - Body Parser                                            │  │
│  │  - JWT Authentication                                     │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                │                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Controllers Layer                                        │  │
│  │  Business Logic & Request Handling                        │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                │                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Services Layer                                           │  │
│  │  - Spotify API                                            │  │
│  │  - OpenWeather API                                        │  │
│  │  - Google Gemini AI                                       │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                │                                │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Models Layer (Mongoose)                                 │   │
│  │  User, Material, Quiz, Session, Goal, Event              │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
                    ▼                         ▼
    ┌──────────────────────────┐  ┌──────────────────────────┐
    │   MongoDB Atlas          │  │  External APIs           │
    │   (Database)             │  │  - Spotify               │
    │   - Users                │  │  - OpenWeather           │
    │   - Materials            │  │  - Gemini AI             │
    │   - Quizzes              │  │                          │
    │   - Sessions             │  │                          │
    │   - Goals                │  │                          │
    │   - Events               │  │                          │
    └──────────────────────────┘  └──────────────────────────┘
```

## 🔄 Request Flow

### Authentication Flow

```
User → Frontend → POST /api/auth/login
                      │
                      ▼
                  Validate credentials
                      │
                      ▼
                  Generate JWT token
                      │
                      ▼
                  Return token to client
                      │
                      ▼
    Client stores token in localStorage
```

### Protected Endpoint Flow

```
User → Frontend → Request with JWT
                      │
                      ▼
                  Auth Middleware
                      │
                  ┌───┴───┐
                  │ Valid │
                  └───┬───┘
                      ▼
                  Controller
                      │
                      ▼
                  Database Query
                      │
                      ▼
                  Return Response
```

## 📁 File Structure & Responsibilities

```
backend/
│
├── src/
│   └── server.js              # Main entry point for Vercel
│       - Initializes Express app
│       - Connects to MongoDB
│       - Sets up middleware
│       - Defines routes
│       - Exports app for Vercel
│
├── config/
│   └── db.js                  # Database configuration
│       - MongoDB connection logic
│       - Connection pooling
│       - Error handling
│
├── controllers/
│   └── controllers.js         # Request handlers
│       - Authentication (register, login)
│       - Profile management
│       - Study materials CRUD
│       - Quiz operations
│       - Progress tracking
│       - Goals management
│       - Events/planner
│       - Music recommendations
│       - Weather data
│       - AI chat
│
├── middleware/
│   └── middleware.js          # Custom middleware
│       - JWT verification
│       - User authentication
│       - Error handling
│
├── models/
│   └── models.js              # Mongoose schemas
│       - User model
│       - StudyMaterial model
│       - Quiz model
│       - StudySession model
│       - Goal model
│       - Event model
│
├── routes/
│   └── routes.js              # API routes
│       - Route definitions
│       - Endpoint mapping
│       - Middleware application
│
├── services/
│   └── services.js            # External services
│       - Spotify API integration
│       - OpenWeather API
│       - Google Gemini AI
│
├── swagger/
│   └── swaggerConfig.js       # API documentation
│       - OpenAPI specification
│       - Endpoint documentation
│
├── views/
│   └── views.js               # Response messages
│       - Success/error messages
│       - Response formatting
│
├── public/
│   ├── index.html            # API landing page
│   ├── swagger.html          # Swagger UI
│   └── favicon.svg           # Favicon
│
├── vercel.json               # Vercel configuration
├── .vercelignore             # Ignore rules
├── .env.example              # Environment template
└── package.json              # Dependencies & scripts
```

## 🔐 Security Layers

```
┌─────────────────────────────────────────────────────┐
│  Layer 1: Network Security (Vercel Edge)            │
│  - DDoS protection                                  │
│  - SSL/TLS encryption                               │
│  - Rate limiting                                    │
└─────────────────────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────┐
│  Layer 2: CORS Policy                               │
│  - Restrict allowed origins                         │
│  - Control HTTP methods                             │
│  - Header whitelisting                              │
└─────────────────────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────┐
│  Layer 3: JWT Authentication                        │
│  - Token verification                               │
│  - Expiration checking                              │
│  - User identification                              │
└─────────────────────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────┐
│  Layer 4: Input Validation                          │
│  - Request body validation                          │
│  - Query parameter sanitization                     │
│  - Type checking                                    │
└─────────────────────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────┐
│  Layer 5: Database Security                         │
│  - Parameterized queries (Mongoose)                 │
│  - NoSQL injection prevention                       │
│  - Data encryption at rest                          │
└─────────────────────────────────────────────────────┘
```

## 📊 Data Flow Examples

### Creating a Quiz

```
Frontend                Backend                 Database
   │                       │                       │
   ├──POST /api/quizzes───>│                       │
   │   + JWT token          │                       │
   │   + Quiz data          │                       │
   │                        │                       │
   │                   Verify JWT                   │
   │                        │                       │
   │                   Validate data                │
   │                        │                       │
   │                        ├──Save Quiz───────────>│
   │                        │                       │
   │                        │<──Saved Quiz──────────┤
   │                        │                       │
   │<───Return success──────┤                       │
   │    + Quiz ID           │                       │
```

### Taking a Quiz

```
Frontend                Backend                 Database
   │                       │                       │
   ├──POST /api/quizzes/  │                       │
   │   :id/attempt         │                       │
   │   + JWT token         │                       │
   │   + Answers           │                       │
   │                       │                       │
   │                  Verify JWT                   │
   │                       │                       │
   │                       ├──Get Quiz────────────>│
   │                       │                       │
   │                       │<──Quiz data───────────┤
   │                       │                       │
   │                  Calculate score              │
   │                       │                       │
   │                       ├──Save attempt────────>│
   │                       │                       │
   │<──Return results──────┤                       │
   │   + Score             │                       │
   │   + Feedback          │                       │
```

## 🚀 Deployment Architecture

### Development

```
Local Machine
├── npm run dev
├── http://localhost:5000
└── Direct MongoDB connection
```

### Production (Vercel)

```
Git Push → GitHub
     │
     ▼
Vercel Auto-Deploy
     │
     ├── Build: npm install
     ├── Deploy: src/server.js
     └── Environment: Production vars
     │
     ▼
Vercel Edge Network
     │
     ├── Region: Automatic (closest to user)
     ├── Cold Start: < 1s
     └── Scaling: Automatic
     │
     ▼
MongoDB Atlas
     │
     ├── Connection Pool: Managed
     ├── Region: Closest to Vercel
     └── Replication: 3-node cluster
```

## 📈 Performance Optimization

```
Request → Vercel Edge Cache
              │
              ├─ Cache Hit → Return cached response
              │
              └─ Cache Miss
                    │
                    ▼
              Serverless Function
                    │
                    ├─ Connection Pool (MongoDB)
                    ├─ Query Optimization
                    ├─ Data Transformation
                    └─ Response Compression
                    │
                    ▼
              Return Response + Set Cache
```

## 🔄 API Versioning Strategy

```
Current: /api/*
Future:  /api/v2/*

Example:
/api/auth/login        → Current version
/api/v2/auth/login     → Future version (backwards compatible)
```

## 📊 Monitoring & Logging

```
Application Logs → Vercel Dashboard
                       │
                       ├─ Function Logs
                       ├─ Error Tracking
                       ├─ Performance Metrics
                       └─ Usage Analytics

Database Logs → MongoDB Atlas
                       │
                       ├─ Query Performance
                       ├─ Connection Stats
                       ├─ Storage Metrics
                       └─ Slow Query Logs
```

## 🎯 Key Technologies

| Technology | Purpose        | Version |
| ---------- | -------------- | ------- |
| Node.js    | Runtime        | 18.x+   |
| Express.js | Web Framework  | 4.x     |
| MongoDB    | Database       | 6.x     |
| Mongoose   | ODM            | 8.x     |
| JWT        | Authentication | 9.x     |
| Vercel     | Hosting        | -       |
| Swagger    | Documentation  | 5.x     |

---

**Last Updated**: 2024-12-07
**Architecture Version**: 1.0.0
