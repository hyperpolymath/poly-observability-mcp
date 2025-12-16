// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
// main.js - Entry shim for poly-observability-mcp (ReScript compiled)

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

// Import ReScript compiled adapters when available
// import * as Prometheus from "./lib/es6/src/adapters/Prometheus.res.js";
// import * as Grafana from "./lib/es6/src/adapters/Grafana.res.js";
// import * as Loki from "./lib/es6/src/adapters/Loki.res.js";

const VERSION = "1.0.0";
const adapters = [];

async function main() {
  const server = new McpServer({
    name: "poly-observability-mcp",
    version: VERSION,
  });

  const connectedAdapters = [];
  const allTools = {};

  for (const adapter of adapters) {
    try {
      await adapter.connect();
      connectedAdapters.push(adapter);
      for (const [name, def] of Object.entries(adapter.tools)) {
        allTools[name] = def;
      }
    } catch (err) {
      console.error(`Failed to connect ${adapter.name}: ${err.message}`);
    }
  }

  for (const [name, tool] of Object.entries(allTools)) {
    const inputSchema = { type: "object", properties: {} };
    for (const [paramName, paramDef] of Object.entries(tool.params)) {
      inputSchema.properties[paramName] = {
        type: paramDef.type_,
        description: paramDef.description,
      };
    }
    server.tool(name, tool.description, inputSchema, async (args) => {
      try {
        const result = await tool.handler(args);
        return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
      } catch (err) {
        return { content: [{ type: "text", text: `Error: ${err.message}` }], isError: true };
      }
    });
  }

  const transport = new StdioServerTransport();
  await server.connect(transport);

  console.error(`poly-observability-mcp v${VERSION} (STDIO mode)`);
  console.error(`Observability tools: Prometheus, Grafana, Loki, Jaeger, OpenTelemetry`);
  console.error(`${connectedAdapters.length} adapter(s), ${Object.keys(allTools).length} tools`);
  console.error("Feedback: https://github.com/hyperpolymath/poly-observability-mcp/issues");
}

main().catch(console.error);
