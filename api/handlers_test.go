package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealthHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/health", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(HealthHandler)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
	}

	var response HealthResponse
	if err := json.Unmarshal(rr.Body.Bytes(), &response); err != nil {
		t.Errorf("failed to unmarshal response: %v", err)
	}

	expected := "ok"
	if response.Status != expected {
		t.Errorf("handler returned unexpected body: got %v want %v", response.Status, expected)
	}
}

func TestWeatherHandler(t *testing.T) {
	config := &Config{
		Weather: struct {
			APIKey  string `yaml:"api_key"`
			BaseURL string `yaml:"base_url"`
		}{
			APIKey:  "test-api-key",
			BaseURL: "https://api.openweathermap.org/data/2.5/weather",
		},
	}

	tests := []struct {
		name           string
		queryParam     string
		expectedStatus int
	}{
		{
			name:           "missing city parameter",
			queryParam:     "",
			expectedStatus: http.StatusBadRequest,
		},
		{
			name:           "with city parameter",
			queryParam:     "London",
			expectedStatus: http.StatusInternalServerError, // Will fail due to invalid API key, but that's expected
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			req, err := http.NewRequest("GET", "/weather?city="+tt.queryParam, nil)
			if err != nil {
				t.Fatal(err)
			}

			rr := httptest.NewRecorder()
			handler := WeatherHandler(config)

			handler.ServeHTTP(rr, req)

			if status := rr.Code; status != tt.expectedStatus {
				t.Errorf("handler returned wrong status code: got %v want %v", status, tt.expectedStatus)
			}

			if tt.expectedStatus == http.StatusBadRequest {
				var response map[string]string
				if err := json.Unmarshal(rr.Body.Bytes(), &response); err != nil {
					t.Errorf("failed to unmarshal error response: %v", err)
				}

				if response["error"] != "city parameter is required" {
					t.Errorf("unexpected error message: got %v", response["error"])
				}
			}
		})
	}
}