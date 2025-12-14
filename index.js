// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
/**
 * poly-observability-mcp - Unified MCP Server for Observability
 *
 * Supported Observability Tools:
 * - Prometheus (Metrics)
 * - Grafana (Dashboards)
 * - Loki (Logs)
 * - Jaeger (Tracing)
 * - OpenTelemetry
 * - Alertmanager
 * - VictoriaMetrics
 * - Tempo
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

// Import adapters (to be implemented)
// import { prometheusAdapter } from "./adapters/prometheus.js";
// import { grafanaAdapter } from "./adapters/grafana.js";
// import { lokiAdapter } from "./adapters/loki.js";
// import { jaegerAdapter } from "./adapters/jaeger.js";
// import { otelAdapter } from "./adapters/opentelemetry.js";

const adapters = [
  // prometheusAdapter,
  // grafanaAdapter,
  // lokiAdapter,
  // jaegerAdapter,
  // otelAdapter,
];

const server = new Server(
  {
    name: "poly-observability-mcp",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Collect all tools from adapters
const allTools = adapters.flatMap((adapter) => adapter.tools || []);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: allTools.map((tool) => ({
    name: tool.name,
    description: tool.description,
    inputSchema: tool.inputSchema,
  })),
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  for (const adapter of adapters) {
    const tool = adapter.tools?.find((t) => t.name === name);
    if (tool) {
      try {
        const result = await tool.handler(args);
        return {
          content: [{ type: "text", text: JSON.stringify(result, null, 2) }],
        };
      } catch (error) {
        return {
          content: [{ type: "text", text: `Error: ${error.message}` }],
          isError: true,
        };
      }
    }
  }

  return {
    content: [{ type: "text", text: `Unknown tool: ${name}` }],
    isError: true,
  };
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("poly-observability-mcp server started");
}

main().catch(console.error);
