package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	config, err := LoadConfig("config.yaml")
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	router := SetupRoutes()

	addr := fmt.Sprintf(":%d", config.Server.Port)
	log.Printf("Starting server on %s", addr)
	
	if err := http.ListenAndServe(addr, router); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}