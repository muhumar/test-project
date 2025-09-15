#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import { Client } from "@notionhq/client";
import fs from 'fs/promises';
import path from 'path';

class NotionMCPServer {
  constructor() {
    this.server = new Server(
      {
        name: "notion-docs",
        version: "1.0.0",
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.notion = null;
    this.config = null;
    this.setupHandlers();
  }

  async loadConfig() {
    try {
      const configPath = path.join(process.cwd(), 'config.json');
      const configData = await fs.readFile(configPath, 'utf-8');
      this.config = JSON.parse(configData);
      
      this.notion = new Client({
        auth: this.config.notion.token,
      });
    } catch (error) {
      console.error('Failed to load config:', error.message);
    }
  }

  setupHandlers() {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: [
        {
          name: "create_build_log",
          description: "Create a new build log entry in Notion",
          inputSchema: {
            type: "object",
            properties: {
              title: { type: "string", description: "Build title" },
              status: { type: "string", description: "Build status (success/failed/in-progress)" },
              details: { type: "string", description: "Build details or logs" },
              component: { type: "string", description: "Component built (frontend/backend/api)" }
            },
            required: ["title", "status"]
          }
        },
        {
          name: "update_project_docs",
          description: "Update project documentation in Notion",
          inputSchema: {
            type: "object",
            properties: {
              section: { type: "string", description: "Documentation section" },
              content: { type: "string", description: "Content to add/update" },
              type: { type: "string", description: "Type of update (feature/bugfix/refactor)" }
            },
            required: ["section", "content"]
          }
        },
        {
          name: "log_deployment",
          description: "Log deployment status to Notion",
          inputSchema: {
            type: "object",
            properties: {
              environment: { type: "string", description: "Deployment environment" },
              status: { type: "string", description: "Deployment status" },
              version: { type: "string", description: "Version deployed" },
              notes: { type: "string", description: "Deployment notes" }
            },
            required: ["environment", "status"]
          }
        }
      ]
    }));

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      if (!this.notion || !this.config) {
        await this.loadConfig();
        if (!this.notion) {
          throw new Error("Notion client not configured. Please check config.json");
        }
      }

      try {
        switch (name) {
          case "create_build_log":
            return await this.createBuildLog(args);
          case "update_project_docs":
            return await this.updateProjectDocs(args);
          case "log_deployment":
            return await this.logDeployment(args);
          default:
            throw new Error(`Unknown tool: ${name}`);
        }
      } catch (error) {
        throw new Error(`Tool execution failed: ${error.message}`);
      }
    });
  }

  async createBuildLog(args) {
    const { title, status, details = "", component = "general" } = args;
    
    const properties = {
      "Title": {
        title: [{ text: { content: title } }]
      },
      "Status": {
        select: { name: status }
      },
      "Component": {
        select: { name: component }
      },
      "Date": {
        date: { start: new Date().toISOString() }
      }
    };

    const children = [];
    if (details) {
      children.push({
        object: "block",
        type: "paragraph",
        paragraph: {
          rich_text: [{ text: { content: details } }]
        }
      });
    }

    const response = await this.notion.pages.create({
      parent: { database_id: this.config.notion.database_id },
      properties,
      children
    });

    return {
      content: [
        {
          type: "text",
          text: `Build log created successfully: ${title} (${status})`
        }
      ]
    };
  }

  async updateProjectDocs(args) {
    const { section, content, type = "update" } = args;
    
    // Create a new page for documentation updates
    const response = await this.notion.pages.create({
      parent: { database_id: this.config.notion.database_id },
      properties: {
        "Title": {
          title: [{ text: { content: `Docs: ${section}` } }]
        },
        "Status": {
          select: { name: "documentation" }
        },
        "Component": {
          select: { name: type }
        },
        "Date": {
          date: { start: new Date().toISOString() }
        }
      },
      children: [
        {
          object: "block",
          type: "heading_2",
          heading_2: {
            rich_text: [{ text: { content: section } }]
          }
        },
        {
          object: "block",
          type: "paragraph",
          paragraph: {
            rich_text: [{ text: { content: content } }]
          }
        }
      ]
    });

    return {
      content: [
        {
          type: "text",
          text: `Documentation updated: ${section}`
        }
      ]
    };
  }

  async logDeployment(args) {
    const { environment, status, version = "latest", notes = "" } = args;
    
    const response = await this.notion.pages.create({
      parent: { database_id: this.config.notion.database_id },
      properties: {
        "Title": {
          title: [{ text: { content: `Deploy to ${environment}` } }]
        },
        "Status": {
          select: { name: status }
        },
        "Component": {
          select: { name: "deployment" }
        },
        "Date": {
          date: { start: new Date().toISOString() }
        }
      },
      children: [
        {
          object: "block",
          type: "paragraph",
          paragraph: {
            rich_text: [
              { text: { content: `Environment: ${environment}\\n` } },
              { text: { content: `Version: ${version}\\n` } },
              { text: { content: `Status: ${status}` } }
            ]
          }
        },
        ...(notes ? [{
          object: "block",
          type: "paragraph",
          paragraph: {
            rich_text: [{ text: { content: notes } }]
          }
        }] : [])
      ]
    });

    return {
      content: [
        {
          type: "text",
          text: `Deployment logged: ${environment} (${status})`
        }
      ]
    };
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error("Notion MCP server running on stdio");
  }
}

const server = new NotionMCPServer();
server.run().catch(console.error);