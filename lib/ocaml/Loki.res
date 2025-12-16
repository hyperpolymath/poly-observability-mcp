// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/// Loki log aggregation adapter
/// Connects to Loki HTTP API for log queries

open Adapter

let baseUrl = ref(Deno.Env.getWithDefault("LOKI_URL", "http://localhost:3100"))
let connected = ref(false)

let name = "loki"
let description = "Loki log aggregation adapter"

let connect = async () => {
  // Test connection to Loki
  let url = baseUrl.contents ++ "/ready"
  switch await Deno.Fetch.get(url) {
  | Ok(_) => connected := true
  | Error(e) => Exn.raiseError(`Failed to connect to Loki: ${e}`)
  }
}

let disconnect = async () => {
  connected := false
}

let isConnected = async () => connected.contents

// Query logs (instant query)
let queryHandler = async (args: dict<JSON.t>): JSON.t => {
  let query = switch Dict.get(args, "query") {
  | Some(JSON.String(q)) => q
  | _ => Exn.raiseError("query parameter is required")
  }
  let limit = switch Dict.get(args, "limit") {
  | Some(JSON.Number(n)) => Float.toInt(n)
  | _ => 100
  }
  let time = switch Dict.get(args, "time") {
  | Some(JSON.String(t)) => Some(t)
  | _ => None
  }

  let url = switch time {
  | Some(t) => `${baseUrl.contents}/loki/api/v1/query?query=${query}&limit=${Int.toString(limit)}&time=${t}`
  | None => `${baseUrl.contents}/loki/api/v1/query?query=${query}&limit=${Int.toString(limit)}`
  }

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Query logs (range query)
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
  let limit = switch Dict.get(args, "limit") {
  | Some(JSON.Number(n)) => Float.toInt(n)
  | _ => 100
  }
  let direction = switch Dict.get(args, "direction") {
  | Some(JSON.String(d)) => d
  | _ => "backward"
  }

  let url = `${baseUrl.contents}/loki/api/v1/query_range?query=${query}&start=${start}&end=${end_}&limit=${Int.toString(limit)}&direction=${direction}`

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get all label names
let labelsHandler = async (args: dict<JSON.t>): JSON.t => {
  let start = switch Dict.get(args, "start") {
  | Some(JSON.String(s)) => Some(s)
  | _ => None
  }
  let end_ = switch Dict.get(args, "end") {
  | Some(JSON.String(e)) => Some(e)
  | _ => None
  }

  let url = switch (start, end_) {
  | (Some(s), Some(e)) => `${baseUrl.contents}/loki/api/v1/labels?start=${s}&end=${e}`
  | _ => `${baseUrl.contents}/loki/api/v1/labels`
  }

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get label values
let labelValuesHandler = async (args: dict<JSON.t>): JSON.t => {
  let label = switch Dict.get(args, "label") {
  | Some(JSON.String(l)) => l
  | _ => Exn.raiseError("label parameter is required")
  }
  let start = switch Dict.get(args, "start") {
  | Some(JSON.String(s)) => Some(s)
  | _ => None
  }
  let end_ = switch Dict.get(args, "end") {
  | Some(JSON.String(e)) => Some(e)
  | _ => None
  }

  let url = switch (start, end_) {
  | (Some(s), Some(e)) => `${baseUrl.contents}/loki/api/v1/label/${label}/values?start=${s}&end=${e}`
  | _ => `${baseUrl.contents}/loki/api/v1/label/${label}/values`
  }

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get series matching selectors
let seriesHandler = async (args: dict<JSON.t>): JSON.t => {
  let match_ = switch Dict.get(args, "match") {
  | Some(JSON.String(m)) => m
  | _ => Exn.raiseError("match parameter is required")
  }
  let start = switch Dict.get(args, "start") {
  | Some(JSON.String(s)) => Some(s)
  | _ => None
  }
  let end_ = switch Dict.get(args, "end") {
  | Some(JSON.String(e)) => Some(e)
  | _ => None
  }

  let url = switch (start, end_) {
  | (Some(s), Some(e)) => `${baseUrl.contents}/loki/api/v1/series?match[]=${match_}&start=${s}&end=${e}`
  | _ => `${baseUrl.contents}/loki/api/v1/series?match[]=${match_}`
  }

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Tail logs (returns snapshot, not actual tail)
let tailHandler = async (args: dict<JSON.t>): JSON.t => {
  let query = switch Dict.get(args, "query") {
  | Some(JSON.String(q)) => q
  | _ => Exn.raiseError("query parameter is required")
  }
  let limit = switch Dict.get(args, "limit") {
  | Some(JSON.Number(n)) => Float.toInt(n)
  | _ => 10
  }
  let delayFor = switch Dict.get(args, "delayFor") {
  | Some(JSON.Number(n)) => Float.toInt(n)
  | _ => 0
  }

  let url = `${baseUrl.contents}/loki/api/v1/tail?query=${query}&limit=${Int.toString(limit)}&delay_for=${Int.toString(delayFor)}`

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get index stats
let indexStatsHandler = async (args: dict<JSON.t>): JSON.t => {
  let query = switch Dict.get(args, "query") {
  | Some(JSON.String(q)) => Some(q)
  | _ => None
  }
  let start = switch Dict.get(args, "start") {
  | Some(JSON.String(s)) => Some(s)
  | _ => None
  }
  let end_ = switch Dict.get(args, "end") {
  | Some(JSON.String(e)) => Some(e)
  | _ => None
  }

  let params = []
  switch query {
  | Some(q) => Array.push(params, `query=${q}`)
  | None => ()
  }
  switch start {
  | Some(s) => Array.push(params, `start=${s}`)
  | None => ()
  }
  switch end_ {
  | Some(e) => Array.push(params, `end=${e}`)
  | None => ()
  }

  let queryString = Array.join(params, "&")
  let url = if queryString != "" {
    `${baseUrl.contents}/loki/api/v1/index/stats?${queryString}`
  } else {
    `${baseUrl.contents}/loki/api/v1/index/stats`
  }

  switch await Deno.Fetch.get(url) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

let tools: dict<toolDef> = Dict.fromArray([
  ("loki_query", {
    description: "Execute an instant LogQL query",
    params: Dict.fromArray([
      ("query", stringParam(~description="LogQL query expression")),
      ("limit", numberParam(~description="Maximum number of entries to return (default 100)")),
      ("time", stringParam(~description="Evaluation timestamp (RFC3339 or Unix nanoseconds)")),
    ]),
    handler: queryHandler,
  }),
  ("loki_query_range", {
    description: "Execute a range LogQL query",
    params: Dict.fromArray([
      ("query", stringParam(~description="LogQL query expression")),
      ("start", stringParam(~description="Start timestamp (RFC3339 or Unix nanoseconds)")),
      ("end", stringParam(~description="End timestamp (RFC3339 or Unix nanoseconds)")),
      ("limit", numberParam(~description="Maximum number of entries (default 100)")),
      ("direction", stringParam(~description="Log order: forward or backward (default backward)")),
    ]),
    handler: queryRangeHandler,
  }),
  ("loki_labels", {
    description: "List all label names",
    params: Dict.fromArray([
      ("start", stringParam(~description="Start timestamp (optional)")),
      ("end", stringParam(~description="End timestamp (optional)")),
    ]),
    handler: labelsHandler,
  }),
  ("loki_label_values", {
    description: "List values for a specific label",
    params: Dict.fromArray([
      ("label", stringParam(~description="Label name")),
      ("start", stringParam(~description="Start timestamp (optional)")),
      ("end", stringParam(~description="End timestamp (optional)")),
    ]),
    handler: labelValuesHandler,
  }),
  ("loki_series", {
    description: "List log streams matching a selector",
    params: Dict.fromArray([
      ("match", stringParam(~description="Series selector (e.g., {job=\"varlogs\"})")),
      ("start", stringParam(~description="Start timestamp (optional)")),
      ("end", stringParam(~description="End timestamp (optional)")),
    ]),
    handler: seriesHandler,
  }),
  ("loki_tail", {
    description: "Get recent logs (snapshot of tail)",
    params: Dict.fromArray([
      ("query", stringParam(~description="LogQL query expression")),
      ("limit", numberParam(~description="Maximum number of entries (default 10)")),
      ("delayFor", numberParam(~description="Delay in seconds before fetching")),
    ]),
    handler: tailHandler,
  }),
  ("loki_index_stats", {
    description: "Get index statistics",
    params: Dict.fromArray([
      ("query", stringParam(~description="LogQL query (optional)")),
      ("start", stringParam(~description="Start timestamp (optional)")),
      ("end", stringParam(~description="End timestamp (optional)")),
    ]),
    handler: indexStatsHandler,
  }),
])
