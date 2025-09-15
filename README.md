# Weather Dashboard Monorepo

A responsive weather dashboard built with SvelteKit frontend and Go backend for the YGO Frontend Coding Challenge.

## Project Structure

```
/
├── backend/           # Go API service  
├── frontend/          # SvelteKit application
├── ai-conversations/  # AI development documentation
├── package.json       # Monorepo scripts
├── README.md          # Project documentation
├── CLAUDE.md          # Claude Code guidance
└── task.md           # Original challenge requirements
```

## Features

- 🌤️ Real-time weather data display
- 🔍 City search functionality
- 📱 Responsive design with TailwindCSS
- ⚡ Go backend API service
- 🎨 Pixel-perfect UI matching provided mockup
- 🤖 AI-first development approach

## Tech Stack

- **Frontend**: SvelteKit, TailwindCSS
- **Backend**: Go, Gorilla Mux, CORS
- **Deployment**: Vercel (frontend), containerized Go service
- **Development**: AI-assisted with Claude Code

## Getting Started

### Install Dependencies
```bash
npm run install:all
```

### Development (Both Services)
```bash
npm run dev
```

### Individual Services
```bash
# Frontend only
npm run dev:frontend

# Backend only  
npm run dev:backend
```

## API Endpoints

- `GET /api/weather?city={cityName}` - Returns weather data for specified city
- `GET /health` - Backend health check

## Services

### Frontend (`/frontend/`)
- SvelteKit application on port 5173
- TailwindCSS styling
- Vercel deployment ready

### Backend (`/backend/`)
- Go API service on port 8080
- RESTful weather endpoints
- CORS enabled

## AI Usage

This project was built using an AI-first approach as required by the challenge. All AI conversations and usage documentation can be found in the `/ai-conversations/` folder.