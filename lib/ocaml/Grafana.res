// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/// Grafana dashboard adapter
/// Connects to Grafana HTTP API for dashboard and data source management

open Adapter

let baseUrl = ref(Deno.Env.getWithDefault("GRAFANA_URL", "http://localhost:3000"))
let apiKey = ref(Deno.Env.getWithDefault("GRAFANA_API_KEY", ""))
let connected = ref(false)

let name = "grafana"
let description = "Grafana dashboard and visualization adapter"

let getHeaders = () => {
  let headers = Dict.make()
  let key = apiKey.contents
  if key != "" {
    Dict.set(headers, "Authorization", `Bearer ${key}`)
  }
  Dict.set(headers, "Content-Type", "application/json")
  headers
}

let connect = async () => {
  // Test connection to Grafana
  let url = baseUrl.contents ++ "/api/health"
  switch await Deno.Fetch.get(url, ~headers=getHeaders()) {
  | Ok(_) => connected := true
  | Error(e) => Exn.raiseError(`Failed to connect to Grafana: ${e}`)
  }
}

let disconnect = async () => {
  connected := false
}

let isConnected = async () => connected.contents

// Search dashboards
let searchDashboardsHandler = async (args: dict<JSON.t>): JSON.t => {
  let query = switch Dict.get(args, "query") {
  | Some(JSON.String(q)) => q
  | _ => ""
  }
  let tag = switch Dict.get(args, "tag") {
  | Some(JSON.String(t)) => Some(t)
  | _ => None
  }

  let url = switch tag {
  | Some(t) => `${baseUrl.contents}/api/search?query=${query}&tag=${t}`
  | None => `${baseUrl.contents}/api/search?query=${query}`
  }

  switch await Deno.Fetch.get(url, ~headers=getHeaders()) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get dashboard by UID
let getDashboardHandler = async (args: dict<JSON.t>): JSON.t => {
  let uid = switch Dict.get(args, "uid") {
  | Some(JSON.String(u)) => u
  | _ => Exn.raiseError("uid parameter is required")
  }

  let url = `${baseUrl.contents}/api/dashboards/uid/${uid}`

  switch await Deno.Fetch.get(url, ~headers=getHeaders()) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// List data sources
let listDataSourcesHandler = async (_args: dict<JSON.t>): JSON.t => {
  let url = `${baseUrl.contents}/api/datasources`

  switch await Deno.Fetch.get(url, ~headers=getHeaders()) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get data source by name
let getDataSourceHandler = async (args: dict<JSON.t>): JSON.t => {
  let name = switch Dict.get(args, "name") {
  | Some(JSON.String(n)) => n
  | _ => Exn.raiseError("name parameter is required")
  }

  let url = `${baseUrl.contents}/api/datasources/name/${name}`

  switch await Deno.Fetch.get(url, ~headers=getHeaders()) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// List folders
let listFoldersHandler = async (_args: dict<JSON.t>): JSON.t => {
  let url = `${baseUrl.contents}/api/folders`

  switch await Deno.Fetch.get(url, ~headers=getHeaders()) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get alert rules
let getAlertRulesHandler = async (_args: dict<JSON.t>): JSON.t => {
  let url = `${baseUrl.contents}/api/v1/provisioning/alert-rules`

  switch await Deno.Fetch.get(url, ~headers=getHeaders()) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get annotations
let getAnnotationsHandler = async (args: dict<JSON.t>): JSON.t => {
  let from = switch Dict.get(args, "from") {
  | Some(JSON.String(f)) => f
  | _ => ""
  }
  let to_ = switch Dict.get(args, "to") {
  | Some(JSON.String(t)) => t
  | _ => ""
  }
  let dashboardId = switch Dict.get(args, "dashboardId") {
  | Some(JSON.Number(n)) => Some(Float.toString(n))
  | _ => None
  }

  let params = []
  if from != "" {
    Array.push(params, `from=${from}`)
  }
  if to_ != "" {
    Array.push(params, `to=${to_}`)
  }
  switch dashboardId {
  | Some(id) => Array.push(params, `dashboardId=${id}`)
  | None => ()
  }

  let queryString = Array.join(params, "&")
  let url = if queryString != "" {
    `${baseUrl.contents}/api/annotations?${queryString}`
  } else {
    `${baseUrl.contents}/api/annotations`
  }

  switch await Deno.Fetch.get(url, ~headers=getHeaders()) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

// Get organization info
let getOrgHandler = async (_args: dict<JSON.t>): JSON.t => {
  let url = `${baseUrl.contents}/api/org`

  switch await Deno.Fetch.get(url, ~headers=getHeaders()) {
  | Ok(data) => data
  | Error(e) => Exn.raiseError(e)
  }
}

let tools: dict<toolDef> = Dict.fromArray([
  ("grafana_search_dashboards", {
    description: "Search for dashboards by name or tag",
    params: Dict.fromArray([
      ("query", stringParam(~description="Search query")),
      ("tag", stringParam(~description="Filter by tag")),
    ]),
    handler: searchDashboardsHandler,
  }),
  ("grafana_get_dashboard", {
    description: "Get a dashboard by UID",
    params: Dict.fromArray([
      ("uid", stringParam(~description="Dashboard UID")),
    ]),
    handler: getDashboardHandler,
  }),
  ("grafana_list_datasources", {
    description: "List all configured data sources",
    params: Dict.make(),
    handler: listDataSourcesHandler,
  }),
  ("grafana_get_datasource", {
    description: "Get data source details by name",
    params: Dict.fromArray([
      ("name", stringParam(~description="Data source name")),
    ]),
    handler: getDataSourceHandler,
  }),
  ("grafana_list_folders", {
    description: "List all dashboard folders",
    params: Dict.make(),
    handler: listFoldersHandler,
  }),
  ("grafana_get_alert_rules", {
    description: "Get all alert rules",
    params: Dict.make(),
    handler: getAlertRulesHandler,
  }),
  ("grafana_get_annotations", {
    description: "Get annotations within a time range",
    params: Dict.fromArray([
      ("from", stringParam(~description="Start time (Unix ms or ISO)")),
      ("to", stringParam(~description="End time (Unix ms or ISO)")),
      ("dashboardId", numberParam(~description="Filter by dashboard ID")),
    ]),
    handler: getAnnotationsHandler,
  }),
  ("grafana_get_org", {
    description: "Get current organization info",
    params: Dict.make(),
    handler: getOrgHandler,
  }),
])
