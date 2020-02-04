alias Graphqexl.Schema
alias Graphqexl.Schema.Executable

defmodule Graphqexl.Server.Plug.Schema do
  @moduledoc """
  Makes an `Graphqexl.Schema.executable/1` available to further plugs/handlers
  """
  import Plug.Conn

  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    conn |> assign(:schema, ExecutableSchema |> GenServer.call(:get))
  end
end
