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

defmodule Graphqexl.Schema do
  @moduledoc """
  Structured representation of a GraphQL schema, either built dynamically or
  parsed from a JSON document or GQL string.
  """

  defstruct(
    enums: [],
    interfaces: [],
    mutations: [],
    queries: [],
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
            enums: list(TEnum.t),
            interfaces: list(Interface.t),
            mutations: list(Mutation.t),
            queries: list(Queries.t),
            str: gql,
            subscriptions: list(Subscription.t),
            types: list(Type.t),
            unions: list(Union.t),
          }

  @spec gql(gql | json) :: %Graphqexl.Schema{}
  @doc """
  Parses a gql string into a %Graphqexl.Schema{}.

  Returns %Graphqexl.Schema{}
  """
  def gql(str) when is_binary(str) do
    %Graphqexl.Schema{str: str |> Dsl.preprocess}
  end

  @doc """
  Parses a json map into a %Graphqexl.Schema{}.

  Returns %Graphqexl.Schema{}
  """
  def gql(json) do
    %Graphqexl.Schema{}
  end

  @spec register(GraphqexlSchema.t, component) :: Graphqexl.Schema.t
  @doc """
  Registers the given component on the given schema.

  Returns %Graphqexl.Schema{}
  """
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
