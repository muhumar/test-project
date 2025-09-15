# Agent Coordination System

## Main Prompt

**User:** "Create two specialized AI agents: (1) Dev Agent for code scaffolding, feature implementation, API development, and building with executable bash scripts and JSON configs, (2) QA Agent for comprehensive testing, security audits, performance benchmarks, and quality reports with automated test generation. Include an Agent Coordinator script that orchestrates workflows between both agents. Each agent needs: configuration JSON with roles/capabilities, executable shell script with 5-6 core commands, logging system, and integration with project structure. Provide complete file structure, example commands, and coordination workflows for feature development, API creation, full dev cycles, and pre-deployment validation. Make everything executable and production-ready with proper error handling and comprehensive documentation."

## Claude's Coordination Response

**Claude:** "I'll create a comprehensive agent coordination system that orchestrates both Dev and QA agents for seamless development workflows. This system will provide automated coordination for common development scenarios:

### Agent Coordination Architecture:
```
agents/
├── claude-dev/           # Development automation
├── claude-qa/            # Quality assurance automation  
├── agent-coordinator.sh  # Orchestration engine
└── coordinator.log       # Coordination tracking
```

### Coordination Workflows Implemented:
1. **Feature Development** - Dev scaffold + QA validation
2. **API Development** - Dev endpoint creation + QA testing
3. **Component Development** - Dev component + QA unit tests
4. **Full Development Cycle** - Complete dev + QA pipeline
5. **Pre-Deployment** - Final validation and security checks

Let me implement each workflow with proper agent coordination..."

## Feature Development Workflow

### Feature Development Process:
```bash
workflow_feature_development() {
    local feature_name="$1"
    log "Starting feature development workflow: $feature_name"
    
    echo "🚀 [DEV AGENT] Creating feature scaffold..."
    $DEV_AGENT new-feature "$feature_name"
    
    echo "🔍 [QA AGENT] Running initial validation..."
    $QA_AGENT unit-tests
    
    log "Feature development workflow completed for: $feature_name"
}
```

### Coordination Benefits:
1. **Automated Scaffolding:** Dev agent creates feature structure
2. **Immediate Validation:** QA agent validates the scaffold
3. **Quality Gates:** Ensures quality from the start
4. **Integrated Logging:** Tracks entire workflow

### Example Execution:
```bash
./agent-coordinator.sh feature user-authentication
```

**Output:**
- Creates `feature/user-authentication` Git branch
- Generates feature directory structure
- Runs unit tests to validate setup
- Provides success/failure feedback
- Logs entire process for debugging"

## API Development Workflow

## API Development Workflow

**Claude:** "The API development workflow provides comprehensive endpoint creation and validation:

### API Development Coordination:
```bash
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
}
```

### Multi-Stage Validation:
1. **Code Generation:** Dev agent creates endpoint handler
2. **Build Verification:** Ensures code compiles successfully
3. **Integration Testing:** QA agent tests endpoint functionality
4. **API Contract Validation:** Verifies API specification compliance

### Quality Assurance Chain:
- **Compilation Check:** Code must build successfully
- **Integration Tests:** Endpoint must respond correctly
- **Contract Validation:** API specification compliance
- **Security Validation:** Basic security checks

This ensures every new API endpoint is production-ready."

## Full Development Cycle Workflow

## Full Development Cycle

**Claude:** "The full development cycle provides comprehensive project validation:

### Complete Development Pipeline:
```bash
workflow_full_cycle() {
    log "Starting full development cycle workflow"
    
    echo "🚀 [DEV AGENT] Checking development status..."
    $DEV_AGENT status
    
    echo "🔧 [DEV AGENT] Building all components..."
    $DEV_AGENT build
    
    echo "🔍 [QA AGENT] Running full QA suite..."
    $QA_AGENT full-report
    
    log "Full development cycle completed"
}
```

### Comprehensive Validation Stages:
1. **Status Assessment:** Current development state analysis
2. **Build Verification:** All components compile successfully
3. **Complete QA Suite:** 
   - Unit tests with coverage
   - Integration tests
   - Security audit
   - Performance benchmarks
   - API validation

### Quality Gate Enforcement:
- **Build Gates:** All components must build
- **Test Gates:** All tests must pass
- **Coverage Gates:** Minimum coverage requirements
- **Security Gates:** No critical vulnerabilities
- **Performance Gates:** Response time requirements

### Comprehensive Reporting:
- Development status summary
- Build success/failure details
- Complete QA report with metrics
- Actionable recommendations
- Quality trend analysis"

## Pre-Deployment Workflow

## Pre-Deployment Validation

**Claude:** "The pre-deployment workflow ensures production readiness:

### Pre-Deployment Validation Pipeline:
```bash
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
}
```

### Production Readiness Checks:
1. **Final Build:** Ensure latest code compiles
2. **Security Audit:** Complete vulnerability scan
3. **Performance Testing:** Validate response times and throughput
4. **API Validation:** Verify all endpoints working correctly

### Deployment Decision Matrix:
- ✅ **Build Success:** All components compile
- ✅ **Security Clear:** No HIGH severity findings
- ✅ **Performance Met:** Response times within limits
- ✅ **APIs Valid:** All endpoints responding correctly

### Automated Deployment Gates:
- **Security Gate:** Blocks deployment on critical vulnerabilities
- **Performance Gate:** Alerts on response time degradation
- **API Gate:** Validates all endpoints before deployment
- **Quality Gate:** Ensures minimum quality standards"

## Agent Status and Monitoring

## Agent Status and Monitoring

**Claude:** "The coordination system provides comprehensive monitoring:

### Status Monitoring Features:
```bash
show_status() {
    echo "🤖 Agent Coordination System Status"
    echo "================================="
    
    echo "🚀 [DEV AGENT] Status:"
    $DEV_AGENT status
    
    echo "🔍 [QA AGENT] Last Reports:"
    ls -la "agents/claude-qa/reports/" | tail -5
}
```

### Logging and Tracking:
1. **Centralized Logging:** All coordination activities logged
2. **Agent Activity Tracking:** Individual agent operation logs
3. **Workflow Progress:** Step-by-step workflow execution
4. **Error Reporting:** Detailed error tracking and resolution

### Monitoring Dashboard:
- **Project Structure:** Agent and report locations
- **Dev Agent Status:** Current development state
- **QA Reports:** Recent quality assessments
- **System Health:** Overall agent system status

### Log File Structure:
- `coordinator.log` - Orchestration activities
- `claude-dev/dev-agent.log` - Development activities
- `claude-qa/qa-agent.log` - Quality assurance activities
- `claude-qa/reports/` - Generated QA reports"

## Workflow Customization

**User:** "Can the coordination workflows be customized for specific needs?"

**Claude:** "Yes, the coordination system is designed for flexibility:

### Customization Options:
1. **Workflow Parameters:** Configurable workflow behavior
2. **Agent Commands:** Modular command execution
3. **Quality Gates:** Adjustable quality thresholds
4. **Reporting:** Custom report generation

### Example Customizations:
```bash
# Custom workflow with specific QA focus
workflow_security_focused() {
    $DEV_AGENT build
    $QA_AGENT security-audit
    $QA_AGENT unit-tests
    # Skip performance tests for faster feedback
}

# Custom workflow for performance optimization
workflow_performance_focused() {
    $DEV_AGENT build
    $QA_AGENT performance-test
    $QA_AGENT validate-api
    # Focus on performance metrics
}
```

### Configuration Integration:
- **Agent Configs:** JSON configurations for behavior modification
- **Quality Standards:** Adjustable thresholds and requirements
- **Tool Integration:** Support for additional development tools
- **Reporting Formats:** Multiple output formats supported

This flexibility allows teams to adapt the coordination system to their specific development needs and quality requirements."

## Final Coordination Validation

**User:** "Validate the complete coordination system."

**Claude:** "Agent Coordination System validation complete:

### ✅ Complete System Implementation:
- **Agent Architecture:** Dev + QA + Coordinator
- **Workflow Orchestration:** 5 coordinated workflows
- **Quality Gates:** Automated validation at each stage
- **Comprehensive Logging:** Full activity tracking
- **Error Handling:** Robust error management
- **Documentation:** Complete usage instructions

### ✅ Available Coordination Workflows:
- `./agent-coordinator.sh feature <name>` - Feature development
- `./agent-coordinator.sh api <name>` - API endpoint creation
- `./agent-coordinator.sh component <name>` - Component development
- `./agent-coordinator.sh full-cycle` - Complete development cycle
- `./agent-coordinator.sh pre-deploy` - Pre-deployment validation
- `./agent-coordinator.sh status` - System status monitoring

### ✅ Production Benefits:
- **Automated Quality:** Quality assurance built into every step
- **Consistent Workflows:** Standardized development processes
- **Comprehensive Validation:** Multi-layered quality checks
- **Audit Trail:** Complete tracking of all activities
- **Error Prevention:** Early detection of issues

The Agent Coordination System provides a complete, production-ready automation framework for development and quality assurance workflows!"