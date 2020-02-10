alias Graphqexl.Query.Operation
alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Field,
  Resolver,
}
alias Treex.Tree

defmodule Graphqexl.Schema.Resolver do
  @moduledoc """
  Encapsulates a GraphQL `t:Graphqexl.Schema.Resolver.func/0` tied to a
  `t:Graphqexl.Schema.Field.t/0` or a `t:Graphqexl.Schema.Type.t/0`.
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:for, :func]
  defstruct [:for, :func]

  @type func:: (Map.t, Map.t, Map.t -> term)
  @type resolver_map:: %{atom => atom | %{atom => atom | %{atom => func}}}

  @type t:: %Graphqexl.Schema.Resolver{for: atom, func: func}

  @doc """
  Build a default `t:Graphqexl.Schema.Resolver.t/0` for the given `t:Graphqexl.Schema.Field.t/0` or
  field name. The default resolver looks for an attribute with the given field name on the `parent`
  struct, which will be the result of the resolver function invoked on the field's parent type.

  Returns: `t:Graphqexl.Schema.Resolver.t/0`
  """
  @doc since: "0.1.0"
  @spec default_for(Field.t | atom):: t
  def default_for(field = %Field{}), do: field.name |> default_for
  def default_for(field),
      do: %Resolver{for: field, func: fn(parent, _, _) -> parent |> Map.get(field) end}

  @doc """
  Retrieve the `t:Graphqexl.Schema.Resolver.t/0` from the given `t:Treex.Tree.t/0` that corresponds
  to the given `t:Graphqexl.Query.Operation.t/0`.

  Returns: `t:Graphqexl.Schema.Resolver.t/0`
  """
  @doc since: "0.1.0"
  @spec for_operation(Tree.t, Operation.t):: t
  def for_operation(tree, operation) do
    tree.children
    |> Enum.filter(&(&1.value == operation.type))
    |> List.first
    |> Map.get(:children)
    |> Enum.filter(&(&1.value.for == operation.name))
    |> List.first
    |> Map.get(:value)
  end

  @doc"""
  Merge two resolver `t:Map.t/0`s, with precedence going from left to right. That is, if
  `resolvers` and `other` both contain the same keys with different values, `tree` will take
  precedence.

  Returns: `t:Treex.Tree.t/0`
  """
  @doc since: "0.1.0"
  @spec merge(resolver_map, resolver_map):: resolver_map
  def merge(resolvers, other) when other |> map_size == 0, do: resolvers
  def merge(resolvers, other) when resolvers |> map_size == 0, do: other
  def merge(resolvers, other) do
    other
    |> Enum.reduce(
         resolvers
         |> Enum.reduce(
              %{},
              fn({key, value}, acc) ->
                if value |> is_map && other |> Map.get(key) |> is_map do
                  acc |> Map.update(key, value |> merge(other |> Map.get(key)), &(&1))
                else
                  acc |> Map.update(key, value, &(&1))
                end
              end
            ),
         fn({key, value}, res) ->
           if res |> Enum.member?(key) do
             if value |> is_map && res |> Map.get(key) |> is_map do
               res |> Map.get(key) |> merge(value)
             else
               res
             end
           else
             res |> Map.update(key, value, &(&1))
           end
         end
       )
  end

  @doc """
  Build a resolver tree for the given schema from the given map, inserting the given root value.

  Returns: `t:Treex.Tree.t/0`
  """
  @doc since: "0.1.0"
  @spec tree_from_map(%{atom => func}, Schema.t, atom):: Tree.t
  def tree_from_map(resolvers, schema, root) do
    %Tree{
      value: root,
      children: resolvers
                |> Enum.map(
                     fn({key, value}) ->
                       %Tree{
                         value: key,
                         children: value |> Enum.map(&from_map_pair/1)
                       }
                     end
                   )
    }
    |> validate!(schema)
  end

  @doc"""
  Ensure that the given resolver is valid for the given schema

  Returns: `t:boolean/0`
  """
  @doc since: "0.1.0"
  @spec validate!(Tree.t, Schema.t):: {:ok, t} | {:error, String.t}
  def validate!(resolvers, _schema) do
    # TODO: implement
#    %Tree{value: :schema} = resolvers |> Tree.Intersection.with(schema)
    resolvers
  end

  @doc false
  @spec from_map_pair({atom, func}):: t
  defp from_map_pair({name, func}),
       do: %Tree{value: %Graphqexl.Schema.Resolver{for: name, func: func}, children: []}
end
