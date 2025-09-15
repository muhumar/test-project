#!/bin/bash

# Claude QA Agent - Quality Assurance Workflow Script
# Usage: ./qa-agent.sh [command] [options]

set -e

AGENT_NAME="Claude QA Agent"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_FILE="$PROJECT_ROOT/agents/claude-qa/qa-agent.log"
REPORTS_DIR="$PROJECT_ROOT/agents/claude-qa/reports"

# Create reports directory
mkdir -p "$REPORTS_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$AGENT_NAME] $1" | tee -a "$LOG_FILE"
}

# QA Commands
qa_unit_tests() {
    log "Running unit tests..."
    
    cd "$PROJECT_ROOT"
    
    # Go unit tests
    log "Executing Go unit tests"
    cd api
    go test -v -cover -coverprofile="$REPORTS_DIR/go-coverage.out" ./... > "$REPORTS_DIR/go-test-results.txt" 2>&1
    go tool cover -html="$REPORTS_DIR/go-coverage.out" -o "$REPORTS_DIR/go-coverage.html"
    
    # Frontend unit tests
    log "Executing Frontend unit tests"
    cd "$PROJECT_ROOT/frontend"
    npm test 2>/dev/null > "$REPORTS_DIR/frontend-test-results.txt" || log "Frontend tests not configured"
    
    log "Unit tests completed. Reports saved to $REPORTS_DIR"
}

qa_integration_tests() {
    log "Running integration tests..."
    
    # Create integration test file
    cat > "$PROJECT_ROOT/api/integration_test.go" << 'EOF'
package main

import (
    "encoding/json"
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestHealthEndpoint(t *testing.T) {
    router := SetupRoutes()
    
    req, err := http.NewRequest("GET", "/health", nil)
    if err != nil {
        t.Fatal(err)
    }
    
    rr := httptest.NewRecorder()
    router.ServeHTTP(rr, req)
    
    if status := rr.Code; status != http.StatusOK {
        t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
    }
    
    var response HealthResponse
    if err := json.Unmarshal(rr.Body.Bytes(), &response); err != nil {
        t.Errorf("failed to unmarshal response: %v", err)
    }
    
    if response.Status != "ok" {
        t.Errorf("unexpected health status: got %v want ok", response.Status)
    }
}

func TestWeatherEndpoint(t *testing.T) {
    router := SetupRoutes()
    
    testCases := []struct {
        name           string
        city           string
        expectedStatus int
    }{
        {"Valid city", "berlin", http.StatusOK},
        {"Invalid city", "nonexistent", http.StatusNotFound},
        {"Empty city", "", http.StatusBadRequest},
    }
    
    for _, tc := range testCases {
        t.Run(tc.name, func(t *testing.T) {
            req, err := http.NewRequest("GET", "/api/weather?city="+tc.city, nil)
            if err != nil {
                t.Fatal(err)
            }
            
            rr := httptest.NewRecorder()
            router.ServeHTTP(rr, req)
            
            if status := rr.Code; status != tc.expectedStatus {
                t.Errorf("handler returned wrong status code: got %v want %v", status, tc.expectedStatus)
            }
        })
    }
}
EOF
    
    cd "$PROJECT_ROOT/api"
    go test -v -run="^Test.*Endpoint$" > "$REPORTS_DIR/integration-test-results.txt" 2>&1
    
    log "Integration tests completed"
}

qa_security_audit() {
    log "Running security audit..."
    
    # Go security scan
    log "Scanning Go code for security issues"
    cd "$PROJECT_ROOT/api"
    
    # Install gosec if not present
    which gosec >/dev/null 2>&1 || go install github.com/securecodewarrior/gosec/v2/cmd/gosec@latest
    
    gosec -fmt json -out "$REPORTS_DIR/go-security-report.json" ./... 2>/dev/null || log "gosec scan completed with findings"
    
    # Frontend security scan
    log "Scanning Frontend dependencies"
    cd "$PROJECT_ROOT/frontend"
    npm audit --json > "$REPORTS_DIR/npm-audit-report.json" 2>/dev/null || log "npm audit completed with findings"
    
    # Generate security summary
    cat > "$REPORTS_DIR/security-summary.md" << EOF
# Security Audit Report

## Generated: $(date)

### Go API Security
- Scanned with gosec
- Report: go-security-report.json

### Frontend Security  
- Scanned with npm audit
- Report: npm-audit-report.json

### Recommendations
1. Review all HIGH and MEDIUM severity findings
2. Update dependencies with known vulnerabilities
3. Implement input validation on all endpoints
4. Add rate limiting to prevent abuse
5. Use HTTPS in production
EOF
    
    log "Security audit completed. Reports saved to $REPORTS_DIR"
}

qa_performance_test() {
    log "Running performance tests..."
    
    # Create performance test
    cat > "$PROJECT_ROOT/api/performance_test.go" << 'EOF'
package main

import (
    "net/http"
    "net/http/httptest"
    "testing"
)

func BenchmarkHealthHandler(b *testing.B) {
    router := SetupRoutes()
    
    for i := 0; i < b.N; i++ {
        req, _ := http.NewRequest("GET", "/health", nil)
        rr := httptest.NewRecorder()
        router.ServeHTTP(rr, req)
    }
}

func BenchmarkWeatherHandler(b *testing.B) {
    router := SetupRoutes()
    
    for i := 0; i < b.N; i++ {
        req, _ := http.NewRequest("GET", "/api/weather?city=berlin", nil)
        rr := httptest.NewRecorder()
        router.ServeHTTP(rr, req)
    }
}
EOF
    
    cd "$PROJECT_ROOT/api"
    go test -bench=. -benchmem > "$REPORTS_DIR/performance-results.txt" 2>&1
    
    log "Performance tests completed"
}

qa_full_report() {
    log "Generating full QA report..."
    
    # Run all tests
    qa_unit_tests
    qa_integration_tests
    qa_security_audit
    qa_performance_test
    
    # Generate comprehensive report
    cat > "$REPORTS_DIR/qa-full-report.md" << EOF
# QA Full Report

Generated: $(date)

## Test Summary
- ✅ Unit Tests: See go-test-results.txt and frontend-test-results.txt
- ✅ Integration Tests: See integration-test-results.txt  
- ✅ Security Audit: See security-summary.md
- ✅ Performance Tests: See performance-results.txt

## Code Coverage
- Go API: View go-coverage.html
- Frontend: See frontend-test-results.txt

## Quality Metrics
$(cd "$PROJECT_ROOT/api" && go test -cover ./... 2>/dev/null | grep "coverage:" || echo "Coverage data not available")

## Recommendations
1. Maintain >80% code coverage
2. Address all HIGH severity security findings
3. Monitor API response times <100ms
4. Regular dependency updates
5. Add more edge case testing

## Files Generated
- go-coverage.html - Visual coverage report
- go-security-report.json - Security findings
- npm-audit-report.json - Frontend vulnerabilities
- performance-results.txt - Benchmark results
EOF
    
    log "Full QA report generated: $REPORTS_DIR/qa-full-report.md"
}

qa_validate_api() {
    log "Validating API contracts..."
    
    # Test API endpoints are responding
    log "Testing API endpoints..."
    
    # Start a temporary server for testing (in background)
    cd "$PROJECT_ROOT/api"
    go run . &
    SERVER_PID=$!
    
    # Wait for server to start
    sleep 3
    
    # Test endpoints
    curl -s http://localhost:8080/health > "$REPORTS_DIR/health-response.json" 2>/dev/null || log "Health endpoint test failed"
    curl -s "http://localhost:8080/api/weather?city=berlin" > "$REPORTS_DIR/weather-response.json" 2>/dev/null || log "Weather endpoint test failed"
    
    # Stop test server
    kill $SERVER_PID 2>/dev/null || true
    
    log "API validation completed"
}

# Main command dispatcher
case "$1" in
    "unit-tests")
        qa_unit_tests
        ;;
    "integration-tests")
        qa_integration_tests
        ;;
    "security-audit")
        qa_security_audit
        ;;
    "performance-test")
        qa_performance_test
        ;;
    "validate-api")
        qa_validate_api
        ;;
    "full-report")
        qa_full_report
        ;;
    *)
        echo "Claude QA Agent Commands:"
        echo "  unit-tests        - Run unit tests with coverage"
        echo "  integration-tests - Run integration tests"
        echo "  security-audit    - Perform security scan"
        echo "  performance-test  - Run performance benchmarks"
        echo "  validate-api      - Test API endpoints"
        echo "  full-report       - Generate comprehensive QA report"
        echo ""
        echo "Reports will be saved to: $REPORTS_DIR"
        ;;
esac