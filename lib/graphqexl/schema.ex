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
  import Graphqexl.Tokens

  @moduledoc """
  Structured representation of a GraphQL schema, either built dynamically or
  parsed from a JSON document or GQL string.
  """

  defstruct(
    context: nil,
    enums: %{},
    interfaces: %{},
    mutations: %{},
    queries: %{},
    resolvers: %{},
    subscriptions: %{},
    types: %{},
    unions: %{}
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
            context: (Query.t, Map.t -> Map.t),
            enums: %{atom => TEnum.t},
            interfaces: %{atom => Interface.t},
            mutations: %{atom => Mutation.t},
            queries: %{atom => Query.t},
            resolvers: %{atom => (Map.t, Map.t, Map.t -> Map.t)},
            subscriptions: %{atom => Subscription.t},
            types: %{atom => Type.t},
            unions: %{atom => Union.t} ,
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
  def gql(gql_str) when is_binary(gql_str) do
    gql_str
    |> Dsl.preprocess
    |> split_lines
    |> Enum.reduce(%Graphqexl.Schema{}, &apply_line/2)
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
    schema |> register(:interfaces, component)
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
  defp register(schema, key, component) do
    schema |> Map.update(key, %{}, &(&1 |> add_component(component)))
  end

  @doc false
  defp add_component(map, component) do
    map |> Map.update(component.name, component, &(&1))
  end

  @doc false
  defp apply_line([cmd | args], schema) do
    [str_name | fields_or_values] = args
    name = str_name |> String.to_atom
    case cmd |> String.replace(tokens.argument_placeholder_separator, "") |> String.to_atom do
      :enum -> schema |> Dsl.enum(name, fields_or_values)
      :interface -> schema |> Dsl.interface(name, fields_or_values)
      :mutation -> schema |> Dsl.mutation(name, fields_or_values)
      :query -> schema |> Dsl.query(name, fields_or_values)
      :schema -> schema
      :subscription -> schema |> Dsl.subscription(name, fields_or_values)
      :type ->
        cond do
          name == :Query ->
            fields_or_values
            |> List.first
            |> String.split(tokens.argument_placeholder_separator)
            |> Enum.reduce(schema, &(Dsl.query(&2, &1)))
          name == :Mutation ->
            fields_or_values |> Enum.reduce(schema, &(Dsl.mutation(&2, &1)))
          name == :Subscription ->
            fields_or_values |> Enum.reduce(schema, &(Dsl.subscription(&2, &1)))
          fields_or_values |> is_argument? -> schema |> Dsl.type(name, nil, fields_or_values)
          fields_or_values |> is_custom_scalar? ->
            schema
            |> Dsl.type(
                 name,
                 fields_or_values
                 |> List.first
                 |> String.replace(tokens.custom_scalar_placeholder, "")
               )
          true ->
            {implements, fields} = fields_or_values |> List.pop_at(0)
            schema |> Dsl.type(name, implements, fields)
        end
      :union ->
        [_, type1, type2] = args
        schema |> Dsl.union(name, type1, type2)
      _ -> raise "Unknown token: #{cmd}"
    end
  end

  @doc false
  defp is_custom_scalar?(spec) do
    spec |> list_head_contains(tokens.custom_scalar_placeholder)
  end

  @doc false
  defp is_argument?(spec) do
    spec |> list_head_contains(tokens.argument_delimiter)
  end

  @doc false
  defp list_head_contains(list, needle) do
    list
    |> List.first
    |> String.contains?(needle)
  end

  @doc false
  defp list_head_replace(list, needle, replacement) do
    list
    |> List.first
    |> String.replace(needle, replacement)
  end

  @doc false
  def regex_escape(char), do: "\\#{char}"

  @doc false
  defp semicolonize(value) do
    value |> String.replace(" ", tokens.argument_placeholder_separator)
  end

  @doc false
  defp split_lines(preprocessed) do
    preprocessed
    |> String.split(tokens.newline)
    |> Enum.map(&(String.replace(&1, "#{tokens.argument_delimiter} ", tokens.argument_delimiter)))
    |> Enum.map(fn spec ->
      Regex.replace(
        ~r/(#{regex_escape(tokens.argument.open)}.*#{regex_escape(tokens.argument.close)})/,
        spec, &semicolonize/1
      )
    end)
    |> Enum.map(&(&1 |> String.split(tokens.space)))
  end
end
