alias Graphqexl.Schema.{
  Field,
  Interface,
  Ref,
  Required,
  TEnum,
  Type,
  Union
}

defmodule Graphqexl.Server.Router do
  use Plug.Router
  require Logger

  plug :match
  plug Graphqexl.Server.Plug.Schema
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass: ["text/*"],
                     json_decoder: Jason
  plug :dispatch

  get "/graphql" do
    Logger.debug("Starting request: #{conn |> request_log_str}")
    Logger.info("Finished request: #{conn |> request_log_str}")
    Graphqexl.Server.Plug.call(conn, Graphqexl.Server.Plug.init([]))
  end

  post "/graphql" do
    Logger.debug("Starting request: #{conn |> request_log_str}")
    Logger.info("Finished request: 200 #{conn |> request_log_str}")
    Graphqexl.Server.Plug.call(conn, Graphqexl.Server.Plug.init([]))
  end

  match _ do
    Logger.debug("Starting request: #{conn |> request_log_str}")
    Logger.info("Finished request: #{conn |> request_log_str}")
    send_resp(conn, 404, "Not Found")
  end

  defp request_log_str(conn), do: "[#{conn.method |> String.upcase}] #{conn.request_path}"
end
