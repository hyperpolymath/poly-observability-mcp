// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/// Jaeger distributed tracing adapter
/// Uses Jaeger Query API for trace retrieval

open Adapter

let jaegerUrl = ref(Deno.Env.getWithDefault("JAEGER_URL", "http://localhost:16686"))
let connected = ref(false)

let name = "jaeger"
let description = "Jaeger distributed tracing"

let connect = async () => {
  switch await Deno.Fetch.get(`${jaegerUrl.contents}/api/services`) {
  | Ok(_) => connected := true
  | Error(e) => Exn.raiseError(`Failed to connect to Jaeger: ${e}`)
  }
}

let disconnect = async () => {
  connected := false
}

let isConnected = async () => connected.contents

// List all services
let servicesHandler = async (_args: dict<JSON.t>): JSON.t => {
  switch await Deno.Fetch.get(`${jaegerUrl.contents}/api/services`) {
  | Ok(result) => result
  | Error(e) => Exn.raiseError(e)
  }
}

// Get traces for a service
let tracesHandler = async (args: dict<JSON.t>): JSON.t => {
  let service = switch Dict.get(args, "service") {
  | Some(JSON.String(s)) => s
  | _ => Exn.raiseError("service parameter is required")
  }
  let operation = switch Dict.get(args, "operation") {
  | Some(JSON.String(o)) => Some(o)
  | _ => None
  }
  let limit = switch Dict.get(args, "limit") {
  | Some(JSON.Number(n)) => Float.toInt(n)
  | _ => 20
  }
  let lookback = switch Dict.get(args, "lookback") {
  | Some(JSON.String(l)) => l
  | _ => "1h"
  }

  let params = [`service=${service}`, `limit=${Int.toString(limit)}`, `lookback=${lookback}`]
  switch operation {
  | Some(op) => Array.push(params, `operation=${op}`)
  | None => ()
  }

  let url = `${jaegerUrl.contents}/api/traces?${Array.join(params, "&")}`
  switch await Deno.Fetch.get(url) {
  | Ok(result) => result
  | Error(e) => Exn.raiseError(e)
  }
}

// Get a specific trace by ID
let traceHandler = async (args: dict<JSON.t>): JSON.t => {
  let traceId = switch Dict.get(args, "traceId") {
  | Some(JSON.String(t)) => t
  | _ => Exn.raiseError("traceId parameter is required")
  }

  switch await Deno.Fetch.get(`${jaegerUrl.contents}/api/traces/${traceId}`) {
  | Ok(result) => result
  | Error(e) => Exn.raiseError(e)
  }
}

// Get operations for a service
let operationsHandler = async (args: dict<JSON.t>): JSON.t => {
  let service = switch Dict.get(args, "service") {
  | Some(JSON.String(s)) => s
  | _ => Exn.raiseError("service parameter is required")
  }

  switch await Deno.Fetch.get(`${jaegerUrl.contents}/api/services/${service}/operations`) {
  | Ok(result) => result
  | Error(e) => Exn.raiseError(e)
  }
}

// Get dependencies
let dependenciesHandler = async (args: dict<JSON.t>): JSON.t => {
  let endTs = switch Dict.get(args, "endTs") {
  | Some(JSON.Number(n)) => Float.toInt(n)
  | _ => 0  // Current time in API
  }
  let lookback = switch Dict.get(args, "lookback") {
  | Some(JSON.Number(n)) => Float.toInt(n)
  | _ => 3600000  // 1 hour in ms
  }

  let url = if endTs > 0 {
    `${jaegerUrl.contents}/api/dependencies?endTs=${Int.toString(endTs)}&lookback=${Int.toString(lookback)}`
  } else {
    `${jaegerUrl.contents}/api/dependencies?lookback=${Int.toString(lookback)}`
  }

  switch await Deno.Fetch.get(url) {
  | Ok(result) => result
  | Error(e) => Exn.raiseError(e)
  }
}

let tools: dict<toolDef> = Dict.fromArray([
  ("jaeger_services", {
    description: "List all services in Jaeger",
    params: Dict.make(),
    handler: servicesHandler,
  }),
  ("jaeger_traces", {
    description: "Get traces for a service",
    params: Dict.fromArray([
      ("service", stringParam(~description="Service name")),
      ("operation", stringParam(~description="Operation name (optional)")),
      ("limit", numberParam(~description="Max traces to return (default: 20)")),
      ("lookback", stringParam(~description="Time range (e.g., '1h', '30m')")),
    ]),
    handler: tracesHandler,
  }),
  ("jaeger_trace", {
    description: "Get a specific trace by ID",
    params: Dict.fromArray([
      ("traceId", stringParam(~description="Trace ID")),
    ]),
    handler: traceHandler,
  }),
  ("jaeger_operations", {
    description: "Get operations for a service",
    params: Dict.fromArray([
      ("service", stringParam(~description="Service name")),
    ]),
    handler: operationsHandler,
  }),
  ("jaeger_dependencies", {
    description: "Get service dependency graph",
    params: Dict.fromArray([
      ("endTs", numberParam(~description="End timestamp (ms since epoch)")),
      ("lookback", numberParam(~description="Lookback window in ms")),
    ]),
    handler: dependenciesHandler,
  }),
])
