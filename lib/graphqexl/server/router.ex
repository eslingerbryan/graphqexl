alias Graphqexl.Server

defmodule Graphqexl.Server.Router do
  @moduledoc """
  `Plug.Router`-based server `Plug` to serve as the main entrypoint for the development server. It
  serves both the Graphql Playground developer UI as well as the GraphQL API.
  """
  @moduledoc since: "0.1.0"
  use Plug.Router
  require Logger

  plug :match
  plug Server.Plug.Schema
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass: ["text/*"],
                     json_decoder: Jason
  plug :dispatch

  get "/graphql" do
    "Starting request: #{conn |> request_log_str}" |> Logger.debug
    "Finished request: #{conn |> request_log_str}" |> Logger.info
    conn |> Server.Plug.call([] |> Server.Plug.init)
  end

  post "/graphql" do
    "Starting request: #{conn |> request_log_str}" |> Logger.debug
    "Finished request: 200 #{conn |> request_log_str}" |> Logger.info
    conn |> Server.Plug.call([] |> Server.Plug.init)
  end

  match _ do
    "Starting request: #{conn |> request_log_str}" |> Logger.debug
    "Finished request: #{conn |> request_log_str}" |> Logger.info
    conn |> send_resp(404, "Not Found")
  end

  @doc false
  @spec request_log_str(Plug.Conn.t):: String.t
  defp request_log_str(conn), do: "[#{conn.method |> String.upcase}] #{conn.request_path}"
end
