defmodule Mix.Tasks.Dev do
  @moduledoc """
  [STUB] Run a development server with the specified schema file
  """

  @doc """
  Run the dev server
  ARGS:
    - schema_file: file path where the schema is defined
  """
  @doc since: "0.1.0"
  @spec run([String.t]) :: :ok
  def run([_schema_file]) do
    IO.puts "[TODO] Implement a dev server environment to run here..."
  end
end
