alias Treex.Tree

defmodule Graphqexl.Query do
  @moduledoc """
  GraphQL query, comprised of one or more `%Graphqexl.Query.Operation`s.
  """

  @type json :: Map.t()
  @type gql :: String.t()
  @type t :: %Graphqexl.Query{operations: [t]}

  defstruct operations: []

  @closing_brace "}"
  @opening_brace "{"

  @doc """
  Execute the given query

  Returns: `%Graphqexl.Query.ResultSet{}`
  """
  @doc since: "0.1.0"
  @spec execute(Query.t()) :: ResultSet.t()
  def execute(query) do
    # build context
    # resolve resolver tree into %ResultSet{}
    # serialize into %Operation{}s
    # return %Query{operations: [<operations>]}
  end

  @doc """
  Parse the given json map into a Query

  Returns: %Graphqexl.Query{}
  """
  @doc since: "0.1.0"
  @spec parse(json) :: Query.t()
  def parse(json) do
    # tokenize
    # pass to handler based on operation type (query, mutation, subscription)
    # extract resolver tree
    # validate required arguments and argument types
    # verify all leaves are scalars
  end

  @doc """
  Parse the given gql string (see `Graphqexl.Schema.Dsl`) into a Query

  Returns: `%Graphqexl.Query{}`
  """
  @doc since: "0.1.0"
  @spec parse(gql) :: Query.t()
  def parse(gql) when is_binary(gql) do
    # tokenize
    # pass to handler based on operation type (query, mutation, subscription)
    # extract resolver tree
    # validate required arguments and argument types
    # verify all leaves are scalars
  end

  @doc false
  defp tokenize(gql) do
    gql
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
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
end
