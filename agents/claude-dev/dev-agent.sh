#!/bin/bash

# Claude Dev Agent - Development Workflow Script
# Usage: ./dev-agent.sh [command] [options]

set -e

AGENT_NAME="Claude Dev Agent"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_FILE="$PROJECT_ROOT/agents/claude-dev/dev-agent.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$AGENT_NAME] $1" | tee -a "$LOG_FILE"
}

# Development Commands
dev_new_feature() {
    local feature_name="$1"
    log "Starting new feature development: $feature_name"
    
    # Create feature branch
    cd "$PROJECT_ROOT"
    git checkout -b "feature/$feature_name" 2>/dev/null || log "Branch may already exist"
    
    # Create feature directory structure
    mkdir -p "features/$feature_name"
    
    log "Feature scaffold created for: $feature_name"
}

dev_api_endpoint() {
    local endpoint_name="$1"
    log "Creating new API endpoint: $endpoint_name"
    
    # Generate handler stub
    cat > "$PROJECT_ROOT/api/handlers_${endpoint_name}.go" << EOF
package main

import (
    "encoding/json"
    "net/http"
)

// ${endpoint_name^}Handler handles ${endpoint_name} requests
func ${endpoint_name^}Handler() http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        // TODO: Implement ${endpoint_name} logic
        response := map[string]string{
            "message": "${endpoint_name} endpoint",
            "status": "not implemented"
        }
        
        w.Header().Set("Content-Type", "application/json")
        w.WriteHeader(http.StatusNotImplemented)
        json.NewEncoder(w).Encode(response)
    }
}
EOF
    
    log "API endpoint handler created: $endpoint_name"
}

dev_component() {
    local component_name="$1"
    log "Creating new Svelte component: $component_name"
    
    # Create component directory
    mkdir -p "$PROJECT_ROOT/frontend/src/lib/components"
    
    # Generate component stub
    cat > "$PROJECT_ROOT/frontend/src/lib/components/${component_name}.svelte" << EOF
<script lang="ts">
    // TODO: Add component props and logic
    export let data: any = {};
</script>

<div class="component-${component_name,,}">
    <!-- TODO: Implement ${component_name} component -->
    <h2>${component_name} Component</h2>
    <p>Component implementation needed</p>
</div>

<style>
    .component-${component_name,,} {
        /* TODO: Add component styles */
    }
</style>
EOF
    
    log "Svelte component created: $component_name"
}

dev_build() {
    log "Building project components"
    
    cd "$PROJECT_ROOT"
    
    # Build Go API
    log "Building Go API..."
    cd api && go build . && cd ..
    
    # Build Frontend
    log "Building Frontend..."
    cd frontend && npm run build && cd ..
    
    log "Build completed successfully"
}

dev_status() {
    log "Development Status Report"
    echo "========================="
    echo "Go API Status:"
    cd "$PROJECT_ROOT/api"
    go mod tidy
    go test ./... -v 2>/dev/null && echo "✅ Go tests passing" || echo "❌ Go tests failing"
    
    echo ""
    echo "Frontend Status:"
    cd "$PROJECT_ROOT/frontend"
    npm run check 2>/dev/null && echo "✅ Frontend checks passing" || echo "❌ Frontend checks failing"
    
    echo ""
    echo "Git Status:"
    cd "$PROJECT_ROOT"
    git status --porcelain | wc -l | xargs -I {} echo "📝 {} files modified"
}

# Main command dispatcher
case "$1" in
    "new-feature")
        dev_new_feature "$2"
        ;;
    "api-endpoint")
        dev_api_endpoint "$2"
        ;;
    "component")
        dev_component "$2"
        ;;
    "build")
        dev_build
        ;;
    "status")
        dev_status
        ;;
    *)
        echo "Claude Dev Agent Commands:"
        echo "  new-feature <name>   - Create new feature scaffold"
        echo "  api-endpoint <name>  - Generate API endpoint"
        echo "  component <name>     - Create Svelte component"
        echo "  build               - Build all project components"
        echo "  status              - Show development status"
        ;;
esac