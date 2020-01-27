defmodule Graphqexl.Server.Router do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch
  plug Graphqexl.Server.Plug

  get "/graphql" do
    Logger.info("Finished request: [200] GET /graphql")
    send_resp(conn, 200, "GraphQExL Playground")
  end

  post "/graphql" do
    Logger.info("Finished request: [200] POST /graphql")
  end

  match _ do
    Logger.info("Finished request: [404]")
    send_resp(conn, 404, "oops")
  end
end
