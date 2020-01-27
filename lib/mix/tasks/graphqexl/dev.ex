defmodule Mix.Tasks.Graphqexl.Dev do
  use Mix.Task

  @shortdoc "Starts a server for the given GraphQL schema"

  @moduledoc """
  Starts the application by configuring all endpoints servers to run.

  ## Command line options

  This task accepts the same command-line arguments as `run`.
  For additional information, refer to the documentation for
  `Mix.Tasks.Run`.

  For example, to run `graphqexl.dev` without recompiling:

      mix graphqexl.dev --no-compile

  The `--no-halt` flag is automatically added.

  Note that the `--no-deps-check` flag cannot be used this way,
  because Mix needs to check dependencies to find `phx.server`.

  To run `graphqexl.dev` without checking dependencies, you can run:

      mix do deps.loadpaths --no-deps-check, graphqexl.dev
  """

  @doc false
  def run(args) do
    Mix.Tasks.Run.run run_args() ++ args
  end

  defp run_args do
    if iex_running?(), do: [], else: ["--no-halt"]
  end

  defp iex_running? do
    Code.ensure_loaded?(IEx) and IEx.started?()
  end
end
