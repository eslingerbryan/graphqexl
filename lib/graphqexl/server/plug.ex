alias Graphqexl.Query.ResultSet

defmodule Graphqexl.Server.Plug do
  @moduledoc """
  Server `Plug` to handle parsing and executing GraphQL queries, which can be given as
  `application/json` or `application/graphql`

  TODO: Error handling/rendering
  """
  @moduledoc since: "0.1.0"
  import Plug.Conn

  @type json:: Map.t

  @doc """
  Init callback invoked when a request matching a route including this `t:Plug.t/0` is being
  prepared for handled.

  Returns: `t:list(term.t/0)`
  """
  @doc since: "0.1.0"
  @spec init(list):: list
  def init(options), do: options

  @doc """
  Call callback invoked when a request matching a route including this `t:Plug.t/0` is handled.

  Returns: `t:Plug.Conn.t/0`
  """
  @doc since: "0.1.0"
  @spec call(Plug.Conn.t, list):: Plug.Conn.t
  def call(conn, _opts) do
    # TODO: content negotiation: application/json and application/graphql
    conn
    |> put_resp_content_type("application/json")
    # TODO: determine status
    |> send_result
  end

  @doc false
  @spec send_result(Plug.Conn.t):: Plug.Conn.t
  defp send_result(conn) do
    conn.body_params
    |> Map.get("q")
    |> Graphqexl.Query.parse
    |> Graphqexl.Query.execute(conn.assigns[:schema])
    |> serialize
    |> respond(conn, 200)
  end

  @doc false
  @spec respond(json, Plug.Conn.t, integer):: Plug.Conn.t
  defp respond(response, conn, status), do: conn |> send_resp(status, response)

  @doc false
  @spec serialize(ResultSet.t):: String.t
  defp serialize(result), do: result |> Jason.encode |> elem(1)
end
