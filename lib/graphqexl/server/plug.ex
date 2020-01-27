defmodule Graphqexl.Server.Plug do
  import Plug.Conn

  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    conn
    # content negotation: application/json and application/graphql
    # parse and execute query
    # serialize result set
    # send response
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end
