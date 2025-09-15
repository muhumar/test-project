package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"
)

type HealthResponse struct {
	Status string `json:"status"`
}

type WeatherResponse struct {
	City      string  `json:"city"`
	Temp      float64 `json:"temp"`
	Condition string  `json:"condition"`
	Humidity  int     `json:"humidity"`
}

type WeatherData struct {
	Cities map[string]WeatherResponse `json:"cities"`
}

// @Summary Health check endpoint
// @Description Returns the health status of the API
// @Tags health
// @Produce json
// @Success 200 {object} HealthResponse
// @Router /health [get]
func HealthHandler(w http.ResponseWriter, r *http.Request) {
	response := HealthResponse{Status: "ok"}
	
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	
	json.NewEncoder(w).Encode(response)
}

// @Summary Get weather information
// @Description Fetch weather data for a specified city
// @Tags weather
// @Param city query string true "City name"
// @Produce json
// @Success 200 {object} WeatherResponse
// @Failure 400 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /weather [get]
func WeatherHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		city := r.URL.Query().Get("city")
		if city == "" {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]string{"error": "city parameter is required"})
			return
		}

		weatherData, err := fetchWeatherData(city)
		if err != nil {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]string{"error": "city not found"})
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(weatherData)
	}
}

func fetchWeatherData(city string) (*WeatherResponse, error) {
	data, err := os.ReadFile("weather_data.json")
	if err != nil {
		return nil, fmt.Errorf("failed to read weather data file: %w", err)
	}

	var weatherData WeatherData
	if err := json.Unmarshal(data, &weatherData); err != nil {
		return nil, fmt.Errorf("failed to parse weather data: %w", err)
	}

	cityKey := strings.ToLower(strings.TrimSpace(city))
	weatherInfo, exists := weatherData.Cities[cityKey]
	if !exists {
		return nil, fmt.Errorf("city not found: %s", city)
	}

	return &weatherInfo, nil
}