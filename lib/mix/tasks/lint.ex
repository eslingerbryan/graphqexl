defmodule Mix.Tasks.Lint do
  @moduledoc """
  Perform linting and static analysis using Lefthook as a runner for tools like Credo
  """

  @doc """
  Perform linting and static analysis using Lefthook as a runner for tools like Credo
  """
  @doc since: "0.1.0"
  @spec run([]) :: :ok
  def run([]) do
    IO.puts "[STARTING] Static Analysis..."

    "lefthook" |> System.cmd(["run", "lint"])

    IO.puts "[DONE] Static Analysis"
  end
end
