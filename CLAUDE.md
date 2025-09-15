# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Context

This is a Weather Dashboard coding challenge requiring SvelteKit + TailwindCSS implementation with a 2-hour time limit. The project fetches weather data via API and displays it in a responsive UI matching a specific TailwindCSS mockup.

## Required Implementation

- **SvelteKit API route**: `/api/weather?city={cityName}` returning JSON with city, temperature, condition
- **UI matching exact mockup**: Centered gray background, white rounded card, search input + blue button, weather display
- **External weather API integration**: OpenWeatherMap, WeatherAPI, or mock data
- **AI usage documentation**: `/ai-conversations/`

## Expected Commands

Once SvelteKit is set up:
- `npm run dev` - Development server
- `npm run build` - Production build  
- `npm run preview` - Preview build
- `npm run check` - Type checking

## API Response Format

Weather endpoint must return:
```json
{
  "city": "Berlin", 
  "temperature": 15,
  "condition": "Cloudy"
}
```

## Deployment Target

Vercel deployment required with public GitHub repository.

## Evaluation Priority

AI-first development approach is the primary evaluation criterion - document all AI tool usage extensively.