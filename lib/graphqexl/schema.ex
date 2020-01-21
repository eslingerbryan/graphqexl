alias Graphqexl.Schema.{
  Dsl,
  Enum,
  Interface,
  Mutation,
  Query,
  Subscription,
  Type,
  Union,
}

defmodule Graphqexl.Schema do
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
          Enum.t |
          Interface.t |
          Mutation.t |
          Query.t |
          Subscription.t |
          Type.t |
          Union.t

  @type gql :: String.t()

  @type t ::
          %Graphqexl.Schema{
            enums: list(Enum.t),
            interfaces: list(Interface.t),
            mutations: list(Mutation.t),
            queries: list(Queries.t),
            str: gql,
            subscriptions: list(Subscription.t),
            types: list(Type.t),
            unions: list(Union.t),
          }

  def gql(str) do
    %Graphqexl.Schema{str: str |> Dsl.preprocess}
  end

  @spec register(GraphqexlSchema.t, component) :: Graphqexl.Schema.t
  def register(schema, %Enum{} = component) do
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

  defp register(schema, key, value) do
    schema |> Map.update(key, value, &prepend_list/2)
  end

  defp prepend_list(list, value) do
    list |> List.insert_at(0, value)
  end
end
