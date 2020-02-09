alias Graphqexl.Query
alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Dsl,
  Interface,
  Mutation,
  Query,
  Resolver,
  Subscription,
  TEnum,
  Type,
  Union,
}
alias Graphqexl.Tokens
alias Treex.Tree

defmodule Graphqexl.Schema do
  @moduledoc """
  Structured representation of a GraphQL schema, either built dynamically or
  parsed from a JSON document or GQL string.
  """
  @moduledoc since: "0.1.0"

  defstruct(
    context: nil,
    enums: %{},
    interfaces: %{},
    mutations: %{},
    queries: %{},
    resolvers: %Tree{},
    subscriptions: %{},
    tree: %Tree{},
    types: %{},
    unions: %{}
  )

  @type component::
          TEnum.t |
          Interface.t |
          Mutation.t |
          Query.t |
          Subscription.t |
          Type.t |
          Union.t
  @type gql:: String.t
  @type json:: Map.t

  @type t::
          %Graphqexl.Schema{
            context: (Query.t, Map.t -> Map.t),
            enums: %{atom => TEnum.t},
            interfaces: %{atom => Interface.t},
            mutations: %{atom => Mutation.t},
            queries: %{atom => Query.t},
            resolvers: Tree.t,
            subscriptions: %{atom => Subscription.t},
            tree: Tree.t,
            types: %{atom => Type.t},
            unions: %{atom => Union.t} ,
          }

  @doc """
  Builds an executable schema containing the schema definition as well as resolver map and context
  factory.

  Returns: `t:Graphqexl.Schema.t/0`
  """
  @doc since: "0.1.0"
  @spec executable(gql | t, Map.t, Map.t | nil):: t
  def executable(gql_str_or_schema, resolvers, context \\ nil)
  def executable(gql_str, resolvers, context) when is_binary(gql_str) do
    gql_str |> gql |> executable(resolvers, context)
  end
  def executable(schema = %Graphqexl.Schema{}, resolvers, context) do
    %{schema | context: context, resolvers: resolvers |> Resolver.tree_from_map(schema, :schema)}
  end


  @doc """
  Parses a `t:Graphqexl.Schema.gql/0` string into a `t:Graphqexl.Schema.t/0`.

  Returns: `t:Graphqexl.Schema.t/0`
  """
  @doc since: "0.1.0"
  @spec gql(gql | json) :: t
  def gql(gql_str) when is_binary(gql_str) do
    gql_str
    |> Dsl.preprocess
    |> split_lines
    |> Enum.reduce(%Graphqexl.Schema{}, &apply_line/2)
  end
  def gql(_json), do: %Graphqexl.Schema{}

  @doc """
  Check whether a `t:Graphqexl.Schema.Field.t/0` is defined on the given `t:Graphqexl.Schema.t/0`.

  Returns: `t:boolean/0`
  """
  @doc since: "0.1.0"
  @spec has_field?(Schema.t, atom):: boolean
  # TODO: fix
  def has_field?(_schema, _field), do: true # !is_nil(Traverse.traverse(schema, &({:continue, &1}), :bfs))

  @doc """
  Registers the given `t:Graphqexl.Schema.component/0` on the given `t:Graphqexl.Schema.t/0`.

  Returns `t:Graphqexl.Schema.t/0`
  """
  @doc since: "0.1.0"
  @spec register(t, component):: t
  def register(schema, %TEnum{} = component), do: schema |> register(:enums, component)
  def register(schema, %Interface{} = component), do: schema |> register(:interfaces, component)
  def register(schema, %Mutation{} = component), do: schema |> register(:mutations, component)
  def register(schema, %Query{} = component), do: schema |> register(:queries, component)
  def register(schema, %Type{} = component), do: schema |> register(:types, component)
  def register(schema, %Union{} = component), do: schema |> register(:unions, component)
  def register(schema, %Subscription{} = component),
      do: schema |> register(:subscriptions, component)

  @doc false
  @spec register(t, atom, component):: t
  defp register(schema, key, component),
       do: schema |> Map.update(key, %{}, &(&1 |> add_component(component)))

  @doc false
  @spec add_component(Map.t, component):: Map.t
  defp add_component(map, component), do: map |> Map.update(component.name, component, &(&1))

  @doc false
  @spec apply_line(list(String.t), t):: t
  defp apply_line([cmd | args], schema) do
    [str_name | fields_or_values] = args
    name = str_name |> String.to_atom
    case cmd
         |> String.replace(:argument_placeholder_separator |> Tokens.get, "")
         |> String.to_atom do
      :enum -> schema |> Dsl.enum(name, fields_or_values)
      :interface -> schema |> Dsl.interface(name, fields_or_values)
      :mutation -> schema |> Dsl.mutation(args)
      :query -> schema |> Dsl.query(args)
      :schema -> schema |> Dsl.schema(args)
      :subscription -> schema |> Dsl.subscription(args)
      :type ->
        cond do
          name == :Query ->
            fields_or_values
            |> List.first
            |> String.split(:argument_placeholder_separator |> Tokens.get)
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
                 |> String.replace(:custom_scalar_placeholder |> Tokens.get, "")
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
  @spec is_custom_scalar?(String.t):: boolean
  defp is_custom_scalar?(spec),
       do: spec |> list_head_contains(:custom_scalar_placeholder |> Tokens.get)

  @doc false
  @spec is_argument?(String.t):: boolean
  defp is_argument?(spec) do
    spec |> list_head_contains(:argument_delimiter |> Tokens.get)
  end

  @doc false
  @spec list_head_contains(list, term):: boolean
  defp list_head_contains(list, needle) do
    list
    |> List.first
    |> String.contains?(needle)
  end

  @doc false
  @spec semicolonize(String.t):: String.t
  defp semicolonize(value) do
    value |> String.replace(" ", :argument_placeholder_separator |> Tokens.get)
  end

  @doc false
  @spec split_lines(String.t):: list(String.t)
  defp split_lines(preprocessed) do
    preprocessed
    |> String.split(:newline |> Tokens.get)
    |> Enum.map(&(&1 |> String.replace(
                          "#{:argument_delimiter |> Tokens.get} ",
                          :argument_delimiter |> Tokens.get))
       )
    |> Enum.map(fn spec ->
      Regex.replace(
        ~r/(#{:argument |> Tokens.get |> Map.get(:open) |> Regex.escape}.*#{:argument |> Tokens.get |> Map.get(:close) |> Regex.escape})/,
        spec, &semicolonize/1
      )
    end)
    |> Enum.map(&(&1 |> String.split(:space |> Tokens.get)))
  end
end
