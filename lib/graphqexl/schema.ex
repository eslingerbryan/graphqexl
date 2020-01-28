alias Graphqexl.Query
alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Dsl,
  Interface,
  Mutation,
  Query,
  Subscription,
  TEnum,
  Type,
  Union,
}
alias Treex.Traverse

defmodule Graphqexl.Schema do
  @moduledoc """
  Structured representation of a GraphQL schema, either built dynamically or
  parsed from a JSON document or GQL string.
  """

  defstruct(
    context: %{},
    enums: [],
    interfaces: [],
    mutations: [],
    queries: [],
    resolvers: %{},
    str: "",
    subscriptions: [],
    types: [],
    unions: []
  )

  @type component ::
          TEnum.t |
          Interface.t |
          Mutation.t |
          Query.t |
          Subscription.t |
          Type.t |
          Union.t

  @type gql :: String.t()
  @type json :: Map.t()

  @type t ::
          %Graphqexl.Schema{
            context: ({Query.t, Map.t} -> Map.t),
            enums: list(TEnum.t),
            interfaces: list(Interface.t),
            mutations: list(Mutation.t),
            queries: list(Queries.t),
            resolvers: Map.t,
            str: gql,
            subscriptions: list(Subscription.t),
            types: list(Type.t),
            unions: list(Union.t),
          }

  @doc """
  Builds an executable schema containing the schema definition as well as resolver map and context
  factory.

  Returns: `t:Graphqexl.Schema.t/0`
  """
  @doc since: "0.1.0"
  @spec executable(gql, Map.t, Map.t | nil):: Graphqexl.Schema.t
  def executable(gql_str, resolvers, context \\ nil) do
    %{gql_str |> gql | resolvers: resolvers, context: context }
  end

  @spec gql(gql | json) :: %Graphqexl.Schema{}
  @doc """
  Parses a gql string into a `t:Graphqexl.Schema.t/0`.

  Returns `t:Graphqexl.Schema.t/0`
  """
  @doc since: "0.1.0"
  def gql(str) when is_binary(str) do
    executable_schema = str |> Dsl.preprocess

    executable_schema
    |> String.split("\n")
    |> Enum.each(&(&1 |> IO.puts))

    %Graphqexl.Schema{str: executable_schema}
  end

  @doc """
  Parses a json map into a `t:Graphqexl.Schema.t/0`.

  Returns `t:Graphqexl.Schema.t/0`
  """
  @doc since: "0.1.0"
  def gql(_json) do
    %Graphqexl.Schema{}
  end

  @doc """
  Check whether a field is defined on the given schema.

  Returns: `t:boolean`
  """
  @doc since: "0.1.0"
  @spec has_field?(Schema.t, atom):: boolean
  def has_field?(schema, field) do
    true # TODO: fix
#    !is_nil(Traverse.traverse(schema, &({:continue, &1}), :bfs))
  end

  @spec register(GraphqexlSchema.t, component):: Graphqexl.Schema.t
  @doc """
  Registers the given component on the given schema.

  Returns `t:Graphqexl.Schema.t/0`
  """
  @doc since: "0.1.0"
  def register(schema, %TEnum{} = component) do
    schema |> register(:enums, component)
  end

  def register(schema, %Interface{} = component) do
    schema |> register(:interfacess, component)
  end

  def register(schema, %Mutation{} = component) do
    schema |> register(:mutations, component)
  end

  def register(schema, %Query{} = component) do
    schema |> register(:queries, component)
  end

  def register(schema, %Subscription{} = component) do
    schema |> register(:subscriptions, component)
  end

  def register(schema, %Type{} = component) do
    schema |> register(:types, component)
  end

  def register(schema, %Union{} = component) do
    schema |> register(:unions, component)
  end

  @doc false
  defp register(schema, key, value) do
    schema |> Map.update(key, value, &prepend_list/2)
  end

  @doc false
  defp prepend_list(list, value) do
    list |> List.insert_at(0, value)
  end
end
