defmodule Graphqexl.Server.Plug.Schema do
  @moduledoc """
  `Plug` that makes an `Graphqexl.Schema.executable/1` available to further plugs/handlers, using
  the `Graphqexl.Schema.Executable` GenServer.
  """
  @moduledoc since: "0.1.0"
  import Plug.Conn

  @doc """
  Init callback invoked when a request matching a route including this `t:Plug.t/0` is being
  prepared for handled.

  Returns: `[t:term/0]`
  """
  @doc since: "0.1.0"
  @spec init(list(term)):: list(term)
  def init(options), do: options

  @doc """
  Call callback invoked when a request matching a route including this `t:Plug.t/0` is handled.
  Assigns a `t:Graphqexl.Schema.t/0` to the active `t:Plug.Conn.t/0`'s `assigns` struct under the
  `:schema` key by fetching the loaded `t:Graphqexl.Schema.t/0` from the
  `Graphqexl.Schema.Executable` GenServer.

  Returns: `t:Plug.Conn.t/0`
  """
  @doc since: "0.1.0"
  @spec call(Plug.Conn.t, list(term)):: Plug.Conn.t
  def call(conn, _opts), do: conn |> assign(:schema, ExecutableSchema |> GenServer.call(:get))
end
