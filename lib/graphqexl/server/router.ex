defmodule Graphqexl.Server.Router do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch
  plug Graphqexl.Server.Plug

  get "/graphql" do
    Logger.info("Finished request")
    send_resp(conn, 200, "hello world!")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
