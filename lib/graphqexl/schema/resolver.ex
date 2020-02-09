alias Graphqexl.Query.Operation
alias Graphqexl.Schema
alias Treex.Tree

defmodule Graphqexl.Schema.Resolver do
  @moduledoc """
  Encapsulates a GraphQL resolver function tied to a field or a type.
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:for, :func]
  defstruct [:for, :func]

  @type func:: (Map.t, Map.t, Map.t -> term)

  @type t:: %Graphqexl.Schema.Resolver{for: atom, func: func}

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
