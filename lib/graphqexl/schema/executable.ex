alias Graphqexl.Schema
alias Graphqexl.Utils.FakeData

defmodule Graphqexl.Schema.Executable do
  @moduledoc """
  Establishes a `GenServer` to cache the loadedGraphQL schema.

  Future improvement: use the GenServer as a basis for hot-reloading
  """
  require Logger
  use GenServer

  # TODO: pull schema_path from the init arg / env
  @schema_path "./lib/graphqexl/utils/schema.gql"
  @table :schema

  @doc """
  Handle request messages from external processes for a `:get` operation,
  returning the executable schema. Callback for the GenServer's `call` handling.

  Returns: `t:Graphqexl.Schema.t/0`
  """
  @doc since: "0.1.0"
  @spec handle_call(:get, tuple, term) :: Schema.t
  def handle_call(:get, _, _), do: {:reply, get_schema(), nil}

  @doc """
  Loads, parses and uses `:ets` to cache the configured schema definition.

  `c:GenServer.init/1` callback implementation, called at application bootstrap.

  Returns:
    `{:ok, nil}` when successful
    `{:error, t:String.t/1}` when unsuccessful
  """
  @doc since: "0.1.0"
  @spec init(term):: {:ok, nil} | {:error, String.t}
  def init(init_arg) do
    "Loading schema from #{@schema_path}" |> Logger.debug

    init_arg
    |> cache_init
    |> load_schema
    |> cache_put
    |> succeed
  end

  @doc """
  Starts the schema cache. Triggers the `c:GenServer.init/1` callback and blocks until the callback
  returns. Returns a tuple with contents dependent on the success state of this function and the
  `c:GenServer.init/1` callback.

  Returns
    `{:ok, pid}`
      When successful, where `pid` is the resulting process

    `{:error, {:already_started, pid} | term}`
      When there is an error. If there is already a process for this application, the first key will
      be `:already_started` and `pid` will be the existing process.

    `:ignore`
      When this child should be ignored by the containing supervisor tree
  """
  def start_link(init_arg), do: GenServer.start_link(__MODULE__, init_arg, name: ExecutableSchema)

  @doc false
  defp cache_get(key), do: @table |> :ets.lookup_element(key, 2)

  @doc false
  defp cache_init(_arg), do: @table |> :ets.new([:named_table])

  @doc false
  defp cache_put(value), do: :schema |> cache_put(value)
  defp cache_put(key, value), do: @table |> :ets.insert({key, value})

  @doc false
  defp load_schema(_cache) do
    @schema_path
    |> File.read
    |> elem(1)
    |> schema
  end

  @doc false
  defp create_post(_parent, _args, _context), do: FakeData.posts |> Enum.random

  @doc false
  defp get_post(_parent, args, _context), do: args.id |> FakeData.post

  @doc false
  defp get_user_comments(_parent, args, _context), do: args.userId |> FakeData.user_comments

  @doc false
  defp get_schema, do: cache_get(:schema)

  @doc false
  defp schema(gql) do
    gql |> Schema.executable(%{
      createPost: &create_post/3,
      getPost: &get_post/3,
      getUserComments: &get_user_comments/3,
    })
  end

  @doc false
  defp succeed(false) do
    "Failed to load executable schema" |> Logger.info
    {:stop, "Could not load executable schema"}
  end
  defp succeed(true) do
    "Loaded executable schema" |> Logger.info
    :schema |> cache_get |> inspect |> Logger.debug
    {:ok, nil}
  end
end
