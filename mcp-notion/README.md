# Notion MCP Server

Simple MCP server for automated documentation and build logging to Notion.

## Setup

1. **Install dependencies:**
   ```bash
   cd mcp-notion
   npm install
   ```

2. **Configure Notion:**
   - Create a Notion integration at https://www.notion.so/my-integrations
   - Copy the Internal Integration Token
   - Create a database in Notion with these properties:
     - Title (Title)
     - Status (Select: success, failed, in-progress, documentation, deployment)
     - Component (Select: frontend, backend, api, general, deployment)
     - Date (Date)
   - Share the database with your integration
   - Copy the database ID from the URL

3. **Update config.json:**
   ```json
   {
     "notion": {
       "token": "secret_YOUR_INTEGRATION_TOKEN",
       "database_id": "YOUR_DATABASE_ID"
     }
   }
   ```

## Usage

### Running the MCP Server
```bash
npm start
```

### Available Tools

1. **create_build_log** - Log build status
   ```json
   {
     "title": "API Build Success",
     "status": "success",
     "details": "Go API compiled successfully",
     "component": "backend"
   }
   ```

2. **update_project_docs** - Update documentation
   ```json
   {
     "section": "API Endpoints",
     "content": "Added /weather endpoint with JSON response",
     "type": "feature"
   }
   ```

3. **log_deployment** - Log deployment status
   ```json
   {
     "environment": "production",
     "status": "success",
     "version": "v1.0.0",
     "notes": "Initial deployment with Go API and SvelteKit frontend"
   }
   ```

## Integration with Claude Code

The MCP server can be used with Claude Code to automatically document your development progress.