// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/// Prometheus metrics adapter
/// Connects to Prometheus HTTP API for metrics queries

open Adapter

let baseUrl = ref(Deno.Env.getWithDefault("PROMETHEUS_URL", "http://localhost:9090"))
let connected = ref(false)

let name = "prometheus"
let description = "Prometheus metrics server adapter"

let connect = async () => {
  // Test connection to Prometheus
  let url = baseUrl.contents ++ "/api/v1/status/buildinfo"
  switch await Deno.Fetch.get(url) {
  | Ok(_) => connected := true
  | Error(e) => Exn.raiseError(`Failed to connect to Prometheus: ${e}`)
  }
}

let disconnect = async () => {
  connected := false
}

let isConnected = async () => connected.contents

// Query instant metrics
let queryHandler = async (args: dict<JSON.t>): JSON.t => {
  let query = switch Dict.get(args, "query") {
  | Some(JSON.String(q)) => q
  | _ => Exn.raiseError("query parameter is required")
  }
  let time = switch Dict.get(args, "time") {
  | Some(JSON.String(t)) => Some(t)
  | _ => None
  }

  let url = switch time {
  | Some(t) => `${baseUrl.contents}/api/v1/query?query=${query}&time=${t}`
  | None => `${baseUrl.contents}/api/v1/query?query=${query}`
  }

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Query range metrics
let queryRangeHandler = async (args: dict<JSON.t>): JSON.t => {
  let query = switch Dict.get(args, "query") {
  | Some(JSON.String(q)) => q
  | _ => Exn.raiseError("query parameter is required")
  }
  let start = switch Dict.get(args, "start") {
  | Some(JSON.String(s)) => s
  | _ => Exn.raiseError("start parameter is required")
  }
  let end_ = switch Dict.get(args, "end") {
  | Some(JSON.String(e)) => e
  | _ => Exn.raiseError("end parameter is required")
  }
  let step = switch Dict.get(args, "step") {
  | Some(JSON.String(s)) => s
  | _ => "15s"
  }

  let url = `${baseUrl.contents}/api/v1/query_range?query=${query}&start=${start}&end=${end_}&step=${step}`

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// List all series matching a selector
let seriesHandler = async (args: dict<JSON.t>): JSON.t => {
  let match_ = switch Dict.get(args, "match") {
  | Some(JSON.String(m)) => m
  | _ => Exn.raiseError("match parameter is required")
  }

  let url = `${baseUrl.contents}/api/v1/series?match[]=${match_}`

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// List all label names
let labelsHandler = async (_args: dict<JSON.t>): JSON.t => {
  let url = `${baseUrl.contents}/api/v1/labels`

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// List label values for a specific label
let labelValuesHandler = async (args: dict<JSON.t>): JSON.t => {
  let label = switch Dict.get(args, "label") {
  | Some(JSON.String(l)) => l
  | _ => Exn.raiseError("label parameter is required")
  }

  let url = `${baseUrl.contents}/api/v1/label/${label}/values`

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get current targets
let targetsHandler = async (_args: dict<JSON.t>): JSON.t => {
  let url = `${baseUrl.contents}/api/v1/targets`

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get current alerts
let alertsHandler = async (_args: dict<JSON.t>): JSON.t => {
  let url = `${baseUrl.contents}/api/v1/alerts`

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get alerting rules
let rulesHandler = async (_args: dict<JSON.t>): JSON.t => {
  let url = `${baseUrl.contents}/api/v1/rules`

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

let tools: dict<toolDef> = Dict.fromArray([
  ("prometheus_query", {
    description: "Execute an instant PromQL query",
    params: Dict.fromArray([
      ("query", stringParam(~description="PromQL query expression")),
      ("time", stringParam(~description="Evaluation timestamp (RFC3339 or Unix timestamp)")),
    ]),
    handler: queryHandler,
  }),
  ("prometheus_query_range", {
    description: "Execute a range PromQL query",
    params: Dict.fromArray([
      ("query", stringParam(~description="PromQL query expression")),
      ("start", stringParam(~description="Start timestamp (RFC3339 or Unix)")),
      ("end", stringParam(~description="End timestamp (RFC3339 or Unix)")),
      ("step", stringParam(~description="Query step (e.g., 15s, 1m)")),
    ]),
    handler: queryRangeHandler,
  }),
  ("prometheus_series", {
    description: "List time series matching a selector",
    params: Dict.fromArray([
      ("match", stringParam(~description="Series selector (e.g., up{job=\"prometheus\"})")),
    ]),
    handler: seriesHandler,
  }),
  ("prometheus_labels", {
    description: "List all label names",
    params: Dict.make(),
    handler: labelsHandler,
  }),
  ("prometheus_label_values", {
    description: "List values for a specific label",
    params: Dict.fromArray([
      ("label", stringParam(~description="Label name")),
    ]),
    handler: labelValuesHandler,
  }),
  ("prometheus_targets", {
    description: "Get current scrape targets and their status",
    params: Dict.make(),
    handler: targetsHandler,
  }),
  ("prometheus_alerts", {
    description: "Get current active alerts",
    params: Dict.make(),
    handler: alertsHandler,
  }),
  ("prometheus_rules", {
    description: "Get alerting and recording rules",
    params: Dict.make(),
    handler: rulesHandler,
  }),
])
