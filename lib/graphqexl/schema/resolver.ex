alias Graphqexl.Schema
alias Graphqexl.Schema.Ref
alias Treex.{
  Traverse,
  Tree,
}

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
  Build a resolver tree for the given schema from the given map, inserting the given root value.

  Returns: `t:Treex.Tree.t/0`
  """
  @doc since: "0.1.0"
  @spec tree_from_map(%{atom => func}, Schema.t, atom):: Tree.t
  def tree_from_map(resolvers, schema, root) do
    %Tree{value: root, children: resolvers |> Enum.map(&from_map_pair/1)}
    |> validate!(schema)
  end

  @doc"""
  Ensure that the given resolver is valid for the given schema

  Returns: `t:boolean/0`
  """
  @doc since: "0.1.0"
  @spec validate!(Tree.t, Schema.t):: {:ok, t} | {:error, String.t}
  def validate!(resolvers, schema) do
#    %Tree{value: :schema} = resolvers |> Tree.Intersection.with(schema)
    resolvers
  end

  @doc false
  @spec from_map_pair({atom, func}):: t
  defp from_map_pair({name, func}),
       do: %Tree{value: %Graphqexl.Schema.Resolver{for: name, func: func}, children: []}
end
