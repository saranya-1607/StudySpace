# StudySpace Backend API

A comprehensive RESTful API for the StudySpace study management platform, built with Node.js, Express, and MongoDB.

## 🚀 Features

* **Authentication**: JWT-based user authentication and authorization
* **Study Materials**: Upload, manage, and organize study materials
* **Quiz System**: Create and take quizzes with automatic scoring
* **Progress Tracking**: Log study sessions and track progress
* **Goal Management**: Set and monitor study goals
* **Study Planner**: Calendar-based event management
* **Music Recommendations**: Spotify integration for study music
* **AI Chat**: Google Gemini-powered study assistant
* **Weather Integration**: OpenWeather API integration
* **Profile Management**: User profile and search functionality

## 📋 Prerequisites

* Node.js >= 18.x
* MongoDB (Local or Atlas)
* npm or yarn
* Vercel CLI (for deployment)

## 🛠️ Installation

### Local Development

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd backend
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Set up environment variables**

   ```bash
   cp .env.example .env
   ```

   Edit `.env` and add your credentials:

   ```env
   MONGO_URI=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret
   SPOTIFY_CLIENT_ID=your_spotify_client_id
   SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
   OPENWEATHER_API_KEY=your_openweather_api_key
   GEMINI_API_TOKEN=your_gemini_api_token
   AI_INSTRUCTION=Your AI assistant instructions
   PORT=5000
   NODE_ENV=development
   ```

4. **Start the development server**

   ```bash
   npm run dev
   ```

5. **Access the API**

   * API: `http://localhost:5000/api`
   * Docs: `http://localhost:5000/api-docs`
   * Health: `http://localhost:5000/health`

## 🌐 Vercel Deployment

See `VERCEL_DEPLOYMENT.md` for detailed deployment instructions.

### Quick Deploy

```bash
# Login to Vercel
vercel login

# Deploy
vercel

# Deploy to production
vercel --prod
```

## 📚 API Documentation

Full API documentation is available at `/api-docs` (Swagger UI).

### Base URL

* **Local**: `http://localhost:5000/api`
* **Production**: `https://studyspace-backend-delta.vercel.app/api`

### Authentication

Most endpoints require authentication. Include the JWT token in the Authorization header:

```text
Authorization: Bearer <your_jwt_token>
```

### Key Endpoints

#### Authentication

* `POST /api/auth/register` - Register new user
* `POST /api/auth/login` - Login user
* `POST /api/auth/verify-email` - Verify email
* `POST /api/auth/reset-password` - Reset password

#### Profile

* `GET /api/profile/:userId?` - Get user profile
* `PUT /api/profile` - Update profile
* `GET /api/search` - Search users

#### Study Materials

* `GET /api/study-materials` - Get all materials
* `POST /api/study-materials` - Create material
* `PUT /api/study-materials/:id` - Update material
* `DELETE /api/study-materials/:id` - Delete material

#### Quizzes

* `GET /api/quizzes` - Get all quizzes
* `POST /api/quizzes` - Create quiz
* `POST /api/quizzes/:id/attempt` - Submit quiz attempt
* `DELETE /api/quizzes/:id` - Delete quiz

#### Study Sessions

* `GET /api/study-sessions` - Get sessions
* `POST /api/study-sessions` - Log session

#### Goals

* `GET /api/goals` - Get all goals
* `POST /api/goals` - Create goal
* `PUT /api/goals/:id` - Update goal
* `DELETE /api/goals/:id` - Delete goal

#### Events (Planner)

* `GET /api/events` - Get all events
* `POST /api/events` - Create event
* `PUT /api/events/:id` - Update event
* `DELETE /api/events/:id` - Delete event

#### Study Groups

* `POST /api/groups` - Create study group
* `POST /api/groups/:groupId/sessions` - Create session

#### External Services

* `GET /api/music` - Get music recommendations
* `GET /api/weather` - Get weather data
* `POST /api/ai-chat` - Chat with AI assistant
* `GET /api/cities` - Get city suggestions

## 🗂️ Project Structure

```text
backend/
├── src/
│   └── server.js              # Vercel serverless entry point
├── config/
│   └── db.js                  # MongoDB connection
├── controllers/
│   └── controllers.js         # Request handlers
├── middleware/
│   └── middleware.js          # Auth middleware
├── models/
│   └── models.js              # Mongoose schemas
├── routes/
│   └── routes.js              # API routes
├── services/
│   └── services.js            # External API services
├── swagger/
│   └── swaggerConfig.js       # API documentation config
├── views/
│   └── views.js               # Response messages
├── public/
│   ├── swagger.html           # Swagger UI
│   └── favicon.svg            # Favicon
├── vercel.json                # Vercel configuration
├── .env.example               # Environment variables template
├── .vercelignore              # Vercel ignore file
├── package.json               # Dependencies
└── README.md                  # This file
```

## 🔒 Security

* JWT tokens for authentication
* bcrypt for password hashing
* CORS configured for security
* Environment variables for sensitive data
* Input validation on all endpoints

## 🧪 Testing

```bash
# Test health endpoint
curl http://localhost:5000/health

# Test authentication
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

## 📊 Database Schema

### User Model

* name, email, password (hashed)
* university, major, interests
* profilePicture, bio

### Study Material Model

* userId, title, description
* category, content, fileUrl
* tags, timestamps

### Quiz Model

* userId, title, description
* category, questions (array)
* attempts (array)

### Study Session Model

* userId, subject, duration
* date, notes, productivity

### Goal Model

* userId, title, description
* targetDate, progress, completed
* category, timestamps

### Event Model

* userId, title, description
* startDate, endDate
* category, color, allDay

## 🛠️ Scripts

```bash
npm start             # Start production server
npm run dev           # Start development server with nodemon
npm run vercel        # Deploy to Vercel preview
npm run vercel-prod   # Deploy to Vercel production
```

## 🔧 Configuration

### Environment Variables

All environment variables should be set in `.env` for local development and in the Vercel dashboard for production.

Required variables:

* `MONGO_URI` - MongoDB connection string
* `JWT_SECRET` - Secret for JWT signing
* `SPOTIFY_CLIENT_ID` - Spotify API client ID
* `SPOTIFY_CLIENT_SECRET` - Spotify API client secret
* `OPENWEATHER_API_KEY` - OpenWeather API key
* `GEMINI_API_TOKEN` - Google Gemini API token
* `AI_INSTRUCTION` - Instructions for AI assistant

Optional variables:

* `PORT` - Server port (default: 5000)
* `NODE_ENV` - Environment (development/production)

## 🐛 Troubleshooting

### MongoDB Connection Issues

* Verify connection string format
* Check network access in MongoDB Atlas
* Ensure IP whitelist includes your IP

### CORS Errors

* Update CORS configuration in `src/server.js`
* Add your frontend domain to allowed origins

### Vercel Deployment Fails

* Check Node.js version compatibility
* Verify all dependencies are listed
* Check Vercel function logs

### Cold Start Performance

* Consider using Vercel Edge Functions
* Implement MongoDB connection pooling
* Optimize middleware chain

## 📈 Performance

* MongoDB indexes for faster queries
* JWT token caching
* Efficient middleware chain
* Connection pooling
* Gzip compression

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📝 License

MIT License - see LICENSE file for details

## 👥 Authors

StudySpace Team

## 🔗 Links

* **Frontend**: `https://studyspace-platform.vercel.app/`
* **Frontend Repository**: `https://github.com/saranya-1607/StudySpace/tree/main/frontend/study-space-frontend`
* **API Documentation**: `https://studyspace-backend-delta.vercel.app/api-docs`
* **Backend API**: `https://studyspace-backend-delta.vercel.app/`
* **MongoDB Atlas**: `https://www.mongodb.com/cloud/atlas`
* **Vercel**: `https://vercel.com`

## 📞 Support

For support, create an issue in the repository.

---

Built with ❤️ by the StudySpace Team
