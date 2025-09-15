# AI Agents Setup - Claude Dev & QA Agents

This directory contains two specialized AI agents for automated development and quality assurance workflows.

## 🤖 Agent Architecture

```
agents/
├── claude-dev/           # Development Agent
│   ├── claude-dev-config.json
│   ├── dev-agent.sh
│   └── dev-agent.log
├── claude-qa/            # QA Agent  
│   ├── claude-qa-config.json
│   ├── qa-agent.sh
│   ├── qa-agent.log
│   └── reports/          # Generated QA reports
├── agent-coordinator.sh  # Orchestration script
├── coordinator.log
└── README.md
```

## 🚀 Quick Start

### 1. Check Agent Status
```bash
./agents/agent-coordinator.sh status
```

### 2. Run Full Development Cycle
```bash
./agents/agent-coordinator.sh full-cycle
```

### 3. Create New Feature
```bash
./agents/agent-coordinator.sh feature user-profile
```

## 🔧 Claude Dev Agent

**Primary Role:** Code scaffolding, feature implementation, and architectural decisions

### Capabilities
- Generate project structure and boilerplate code
- Implement new features and API endpoints  
- Create responsive UI components
- Handle routing and state management
- Performance optimization

### Commands
```bash
cd agents/claude-dev

# Create feature scaffold
./dev-agent.sh new-feature <feature-name>

# Generate API endpoint
./dev-agent.sh api-endpoint <endpoint-name>

# Create Svelte component
./dev-agent.sh component <ComponentName>

# Build project
./dev-agent.sh build

# Show development status
./dev-agent.sh status
```

### Example Usage
```bash
# Create a new authentication feature
./dev-agent.sh new-feature authentication

# Add a notifications API endpoint
./dev-agent.sh api-endpoint notifications

# Create a UserCard component
./dev-agent.sh component UserCard
```

## 🔍 Claude QA Agent

**Primary Role:** Quality assurance, testing, and security review

### Capabilities
- Generate comprehensive test suites
- Identify edge cases and error conditions
- Perform security audits
- Validate API contracts
- Performance testing and benchmarks

### Commands
```bash
cd agents/claude-qa

# Run unit tests with coverage
./qa-agent.sh unit-tests

# Run integration tests
./qa-agent.sh integration-tests

# Perform security audit
./qa-agent.sh security-audit

# Run performance benchmarks
./qa-agent.sh performance-test

# Validate API endpoints
./qa-agent.sh validate-api

# Generate full QA report
./qa-agent.sh full-report
```

### Generated Reports
All reports are saved to `agents/claude-qa/reports/`:
- `go-coverage.html` - Visual code coverage report
- `go-security-report.json` - Security scan results
- `npm-audit-report.json` - Frontend vulnerability scan
- `performance-results.txt` - Benchmark results
- `qa-full-report.md` - Comprehensive QA summary

## 🎯 Coordinated Workflows

The agent coordinator orchestrates both agents for common development workflows.

### Available Workflows

#### 1. Feature Development
```bash
./agents/agent-coordinator.sh feature <feature-name>
```
- Creates feature scaffold (Dev Agent)
- Runs validation tests (QA Agent)

#### 2. API Development  
```bash
./agents/agent-coordinator.sh api <endpoint-name>
```
- Creates API endpoint (Dev Agent)
- Builds project (Dev Agent)
- Runs integration tests (QA Agent)
- Validates API contracts (QA Agent)

#### 3. Component Development
```bash
./agents/agent-coordinator.sh component <ComponentName>
```
- Creates Svelte component (Dev Agent)
- Runs unit tests (QA Agent)

#### 4. Full Development Cycle
```bash
./agents/agent-coordinator.sh full-cycle
```
- Checks development status (Dev Agent)
- Builds all components (Dev Agent)  
- Runs comprehensive QA suite (QA Agent)

#### 5. Pre-Deployment
```bash
./agents/agent-coordinator.sh pre-deploy
```
- Final build (Dev Agent)
- Security audit (QA Agent)
- Performance testing (QA Agent)
- API validation (QA Agent)

## 📊 Quality Standards

### Code Coverage Targets
- **Go API:** ≥80% line coverage
- **Frontend:** ≥70% component coverage

### Security Requirements
- All HIGH severity findings must be addressed
- Dependencies must be up-to-date
- API endpoints must have input validation

### Performance Targets
- API response time: <100ms
- Frontend load time: <2s
- Memory usage: <50MB per request

## 🔄 Integration with Development Workflow

### Git Integration
Agents automatically work with Git branches:
```bash
# Agents create feature branches
./agents/agent-coordinator.sh feature payment-system
# Creates: feature/payment-system branch
```

### CI/CD Integration
Add agent commands to your CI/CD pipeline:
```yaml
# Example GitHub Actions integration
- name: Run QA Agent
  run: ./agents/claude-qa/qa-agent.sh full-report

- name: Check Quality Gates
  run: |
    if grep -q "FAIL" agents/claude-qa/reports/qa-full-report.md; then
      exit 1
    fi
```

## 🛠 Customization

### Agent Configuration
Modify agent behavior by editing:
- `claude-dev/claude-dev-config.json` - Dev agent settings
- `claude-qa/claude-qa-config.json` - QA agent settings

### Adding Custom Commands
Extend agent scripts by adding new functions to:
- `claude-dev/dev-agent.sh`
- `claude-qa/qa-agent.sh`

## 📝 Logging and Monitoring

### Log Files
- `claude-dev/dev-agent.log` - Development activities
- `claude-qa/qa-agent.log` - QA activities  
- `coordinator.log` - Orchestration events

### Monitoring Commands
```bash
# Watch dev agent logs
tail -f agents/claude-dev/dev-agent.log

# Watch QA agent logs  
tail -f agents/claude-qa/qa-agent.log

# Watch coordinator logs
tail -f agents/coordinator.log
```

## 🚀 Next Steps

1. **Run Initial Setup:**
   ```bash
   ./agents/agent-coordinator.sh status
   ```

2. **Test Agent Functionality:**
   ```bash
   ./agents/agent-coordinator.sh full-cycle
   ```

3. **Integrate with Development Workflow:**
   - Use agents for new feature development
   - Add to CI/CD pipeline
   - Monitor quality metrics

4. **Customize for Your Needs:**
   - Modify agent configurations
   - Add project-specific commands
   - Set up automated scheduling

## 🆘 Troubleshooting

### Common Issues

**Agent scripts not executable:**
```bash
chmod +x agents/claude-dev/dev-agent.sh
chmod +x agents/claude-qa/qa-agent.sh  
chmod +x agents/agent-coordinator.sh
```

**Missing dependencies:**
```bash
# Install Go tools
go install github.com/securecodewarrior/gosec/v2/cmd/gosec@latest

# Install frontend tools
cd frontend && npm install
```

**Permission errors:**
```bash
# Ensure proper permissions
sudo chown -R $USER:$USER agents/
```

For additional support, check the log files in each agent directory.