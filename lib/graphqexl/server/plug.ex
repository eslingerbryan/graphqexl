defmodule Graphqexl.Server.Plug do
  import Plug.Conn

  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    # content negotiation: application/json and application/graphql
    conn
    |> put_resp_content_type("application/json")
    # determine status
    |> send_result
  end

  defp send_result(conn) do
    conn.body_params
    |> Map.get("q")
    |> Graphqexl.Query.parse
    |> Graphqexl.Query.execute(conn.assigns[:schema])
    |> serialize
    |> respond(conn, 200)
  end

  defp respond(response, conn, status) do
    conn |> send_resp(status, response)
  end

  defp serialize(result) do
    result
    |> (&(Jason.encode(%{data: &1.data, errors: &1.errors}))).()
    |> elem(1)
  end
end
