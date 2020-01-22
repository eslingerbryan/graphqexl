defmodule Graphqexl.Query do
  @moduledoc """
  GraphQL query, comprised of one or more `%Graphqexl.Query.Operation`s.
  """

  @type json :: Map.t()
  @type gql :: String.t()
  @type t :: %Graphqexl.Query{operations: [t]}

  defstruct operations: []

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
  Parse the given [gql string](#Graphqexl.Schema.Dsl) into a Query

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
end
