alias Graphqexl.Query.{
  Operation,
  ResultSet,
  Validator,
}
alias Graphqexl.Schema
alias Treex.{
  Traverse,
  Tree
}

defmodule Graphqexl.Query do
  @moduledoc """
  GraphQL query, comprised of one or more `t:Graphqexl.Query.Operation`s.

  Built by calling `parse/1` with either a gql string (see `Graphqexl.Schema.Dsl`) or json `t:Map`.
  """

  @type json :: Map.t
  @type gql :: String.t
  @type t :: %Graphqexl.Query{operations: [Operation.t]}

  defstruct operations: []

  @closing_brace "}"
  @opening_brace "{"

  @doc """
  Execute the given `t:Graphqexl.Query`

  Returns: `t:Graphqexl.Query.ResultSet`
  """
  @doc since: "0.1.0"
  @spec execute(Graphqexl.Query.t, Schema.t) :: ResultSet.t
  def execute(query, schema) do
    query |> validate!(schema)
    # build parent context
    # resolve resolver tree into %ResultSet{}
    # serialize into %Operation{}s
    # return %Query{operations: [<operations>]}
  end

  @doc """
  Parse the given json map into a `t:Graphqexl.Query`

  Returns: `t:Graphqexl.Query`
  """
  @doc since: "0.1.0"
  @spec parse(json) :: Query.t
  def parse(json) do
    # convert bare map to %Query{}
  end

  @doc """
  Parse the given gql string (see `Graphqexl.Schema.Dsl`) into a `t:Graphqexl.Query`

  Returns: `t:Graphqexl.Query`
  """
  @doc since: "0.1.0"
  @spec parse(gql) :: Query.t
  def parse(gql) when is_binary(gql) do
    gql
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&(String.replace(&1, "\n{", "{")))
    |> Enum.reduce(%{stack: [], treex: %Tree{}}, &tokenize/2)
  end

  @doc false
  defp tokenize(line, %{stack: stack, treex: tree}) do
    unbraced =
      [@closing_brace, @opening_brace]
      |> Enum.reduce(line, &(String.replace(&1, "")))

    new_treex = Traverse.tree_insert(
      %Tree{value: unbraced, children: []},
      stack |> List.first
    )

    new_stack = case line |> String.at(-1) do
      @opening_brace -> stack |> List.insert_at(0, new_treex)
      @closing_brace -> stack |> List.pop_at(0) |> elem(1)
      _ -> stack
    end

    %{stack: new_stack, treex: new_treex}
  end

  @doc false
  defp validate!(query, schema) do
    true = query |> Validator.valid?(schema)
  end
end
