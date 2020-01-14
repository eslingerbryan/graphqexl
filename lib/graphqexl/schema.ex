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
    unions: [],
  )

  def gql(str) do
    %Graphqexl.Schema{str: str |> Dsl.preprocess}
  end

  def register(schema, %Enum{} = enum) do
    schema |> register(:enums, enum)
  end

  def register(schema, %Interface{} = interface) do
    schema |> register(:interfacess, interface)
  end

  def register(schema, %Mutation{} = mutation) do
    schema |> register(:mutationa, mutation)
  end

  def register(schema, %Query{} = query) do
    schema |> register(:queries, query)
  end

  def register(schema, %Subscription{} = subscription) do
    schema |> register(:subscriptions, subscription)
  end

  def register(schema, %Type{} = type) do
    schema |> register(:types, type)
  end

  def register(schema, %Union{} = union) do
    schema |> register(:unions, union)
  end

  defp register(schema, key, value) do
    schema |> Map.update(key, &prepend/2)
  end

  defp prepend(list, value) do
    list |> List.insert_at(0, value)
  end
end
