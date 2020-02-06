alias Graphqexl.Server.Router

defmodule Graphqexl.Application do
  @moduledoc false
  require Logger
  use Application

  @type on_start:: {:ok, pid} | {:error, {:already_started, pid} | {:shutdown, term} | term}

  @doc false
  @spec start(term, list(term)):: on_start
  def start(_type, _args) do
    Logger.info("Starting server at http://localhost:4000")
    children = [
      # TODO: pull schema.gql from configured env
      Graphqexl.Schema.Executable,
      Plug.Cowboy.child_spec(scheme: :http, plug: Router, options: [port: 4000]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Graphqexl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
