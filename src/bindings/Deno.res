// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/// Deno runtime bindings

module Env = {
  @scope(("Deno", "env")) @val
  external get: string => option<string> = "get"

  let getWithDefault = (key: string, default: string): string => {
    switch get(key) {
    | Some(v) => v
    | None => default
    }
  }
}

module Command = {
  type t
  type output = {
    code: int,
    stdout: Js.TypedArray2.Uint8Array.t,
    stderr: Js.TypedArray2.Uint8Array.t,
  }

  type commandOptions = {
    args: array<string>,
    stdout: string,
    stderr: string,
  }

  @new @scope("Deno")
  external make: (string, commandOptions) => t = "Command"

  @send external output: t => promise<output> = "output"

  @new external textDecoder: unit => {"decode": Js.TypedArray2.Uint8Array.t => string} = "TextDecoder"

  let run = async (binary: string, args: array<string>): (int, string, string) => {
    let cmd = make(binary, {args, stdout: "piped", stderr: "piped"})
    let result = await output(cmd)
    let decoder = textDecoder()
    (result.code, decoder["decode"](result.stdout), decoder["decode"](result.stderr))
  }
}
