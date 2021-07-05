defmodule Mix.Tasks.Lint do
  @moduledoc """
  Perform linting and static analysis using Lefthook as a runner for tools like Credo
  """
  @moduledoc since: "0.1.0"

  @doc """
  Perform linting and static analysis using Lefthook as a runner for tools like Credo
  """
  @doc since: "0.1.0"
  @spec run([]) :: :ok
  def run([]) do
    "[STARTING] Static Analysis..." |> IO.puts

    "lefthook" |> System.cmd(["run", "lint"])

    "[DONE] Static Analysis" |> IO.puts
  end
end
