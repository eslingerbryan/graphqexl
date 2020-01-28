defmodule Graphqexl.Server.Plug do
  import Plug.Conn

  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    # content negotiation: application/json and application/graphql
    {:ok, result} =
      conn.body_params
      |> Map.get("q")
      |> Graphqexl.Query.parse
      |> Graphqexl.Query.execute(conn.assigns[:schema])
      |> (&(Jason.encode(%{data: &1.data, errors: &1.errors}))).()

    conn
    |> put_resp_content_type("application/json")
    # determine status
    |> send_resp(200, result)
  end
end
