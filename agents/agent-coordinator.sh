#!/bin/bash

# Agent Coordinator - Orchestrates Claude Dev and QA Agents
# Usage: ./agent-coordinator.sh [workflow] [options]

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEV_AGENT="$PROJECT_ROOT/agents/claude-dev/dev-agent.sh"
QA_AGENT="$PROJECT_ROOT/agents/claude-qa/qa-agent.sh"
LOG_FILE="$PROJECT_ROOT/agents/coordinator.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [COORDINATOR] $1" | tee -a "$LOG_FILE"
}

# Development Workflow: Dev Agent -> QA Agent
workflow_feature_development() {
    local feature_name="$1"
    log "Starting feature development workflow: $feature_name"
    
    echo "🚀 [DEV AGENT] Creating feature scaffold..."
    $DEV_AGENT new-feature "$feature_name"
    
    echo "🔍 [QA AGENT] Running initial validation..."
    $QA_AGENT unit-tests
    
    log "Feature development workflow completed for: $feature_name"
    echo "✅ Feature scaffold created and validated"
}

# API Development Workflow
workflow_api_development() {
    local endpoint_name="$1"
    log "Starting API development workflow: $endpoint_name"
    
    echo "🚀 [DEV AGENT] Creating API endpoint..."
    $DEV_AGENT api-endpoint "$endpoint_name"
    
    echo "🔧 [DEV AGENT] Building project..."
    $DEV_AGENT build
    
    echo "🔍 [QA AGENT] Running comprehensive tests..."
    $QA_AGENT integration-tests
    $QA_AGENT validate-api
    
    log "API development workflow completed for: $endpoint_name"
    echo "✅ API endpoint created, built, and tested"
}

# Full Development Cycle
workflow_full_cycle() {
    log "Starting full development cycle workflow"
    
    echo "🚀 [DEV AGENT] Checking development status..."
    $DEV_AGENT status
    
    echo "🔧 [DEV AGENT] Building all components..."
    $DEV_AGENT build
    
    echo "🔍 [QA AGENT] Running full QA suite..."
    $QA_AGENT full-report
    
    log "Full development cycle completed"
    echo "✅ Complete development cycle executed"
    echo "📊 Check agents/claude-qa/reports/ for detailed reports"
}

# Pre-deployment Workflow
workflow_pre_deployment() {
    log "Starting pre-deployment workflow"
    
    echo "🔧 [DEV AGENT] Final build..."
    $DEV_AGENT build
    
    echo "🔍 [QA AGENT] Security audit..."
    $QA_AGENT security-audit
    
    echo "🔍 [QA AGENT] Performance testing..."
    $QA_AGENT performance-test
    
    echo "🔍 [QA AGENT] API validation..."
    $QA_AGENT validate-api
    
    log "Pre-deployment workflow completed"
    echo "✅ Ready for deployment (pending manual review of reports)"
}

# Component Development Workflow
workflow_component_development() {
    local component_name="$1"
    log "Starting component development workflow: $component_name"
    
    echo "🚀 [DEV AGENT] Creating component..."
    $DEV_AGENT component "$component_name"
    
    echo "🔍 [QA AGENT] Running unit tests..."
    $QA_AGENT unit-tests
    
    log "Component development workflow completed for: $component_name"
    echo "✅ Component created and tested"
}

# Show agent status
show_status() {
    echo "🤖 Agent Coordination System Status"
    echo "================================="
    echo ""
    echo "📁 Project Structure:"
    echo "   Dev Agent:    $DEV_AGENT"
    echo "   QA Agent:     $QA_AGENT"
    echo "   Reports:      $PROJECT_ROOT/agents/claude-qa/reports/"
    echo ""
    echo "🚀 [DEV AGENT] Status:"
    $DEV_AGENT status
    echo ""
    echo "🔍 [QA AGENT] Last Reports:"
    ls -la "$PROJECT_ROOT/agents/claude-qa/reports/" 2>/dev/null | tail -5 || echo "   No reports generated yet"
}

# Main command dispatcher
case "$1" in
    "feature")
        if [ -z "$2" ]; then
            echo "Usage: $0 feature <feature-name>"
            exit 1
        fi
        workflow_feature_development "$2"
        ;;
    "api")
        if [ -z "$2" ]; then
            echo "Usage: $0 api <endpoint-name>"
            exit 1
        fi
        workflow_api_development "$2"
        ;;
    "component")
        if [ -z "$2" ]; then
            echo "Usage: $0 component <component-name>"
            exit 1
        fi
        workflow_component_development "$2"
        ;;
    "full-cycle")
        workflow_full_cycle
        ;;
    "pre-deploy")
        workflow_pre_deployment
        ;;
    "status")
        show_status
        ;;
    *)
        echo "🤖 Agent Coordinator - Orchestrate Claude Dev & QA Agents"
        echo ""
        echo "Available Workflows:"
        echo "  feature <name>     - Create feature scaffold + validation"
        echo "  api <name>         - Create API endpoint + testing"
        echo "  component <name>   - Create component + unit tests"
        echo "  full-cycle         - Complete dev + QA cycle"
        echo "  pre-deploy         - Pre-deployment validation"
        echo "  status             - Show agent system status"
        echo ""
        echo "Examples:"
        echo "  $0 feature user-authentication"
        echo "  $0 api notifications"
        echo "  $0 component WeatherCard"
        echo "  $0 full-cycle"
        ;;
esac