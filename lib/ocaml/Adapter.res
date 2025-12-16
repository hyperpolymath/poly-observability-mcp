// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/// Adapter interface types for IaC tools

type paramDef = {
  @as("type") type_: string,
  description: string,
}

type toolDef = {
  description: string,
  params: dict<paramDef>,
  handler: dict<JSON.t> => promise<JSON.t>,
}

module type Adapter = {
  let name: string
  let description: string
  let connect: unit => promise<unit>
  let disconnect: unit => promise<unit>
  let isConnected: unit => promise<bool>
  let tools: dict<toolDef>
}

let makeParam = (~type_: string, ~description: string): paramDef => {
  {type_, description}
}

let stringParam = (~description: string): paramDef => {
  makeParam(~type_="string", ~description)
}

let boolParam = (~description: string): paramDef => {
  makeParam(~type_="boolean", ~description)
}

let numberParam = (~description: string): paramDef => {
  makeParam(~type_="number", ~description)
}
