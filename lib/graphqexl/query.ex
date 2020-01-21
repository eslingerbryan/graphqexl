defmodule Graphqexl.Query do
  @type json :: Map.t()
  @type gql :: String.t()
  @type t :: %Graphqexl.Query{operations: [t]}

  defstruct operations: []

  @spec execute(Query.t()) :: ResultSet.t()
  def execute(query) do
    # build context
    # resolve resolver tree into %ResultSet{}
    # serialize into %Operation{}s
    # return %Query{operations: [<operations>]}
  end

  @spec parse(json) :: Query.t()
  def parse(json) do
    # tokenize
    # pass to handler based on operation type (query, mutation, subscription)
    # extract resolver tree
    # validate required arguments and argument types
    # verify all leaves are scalars
  end

  @spec parse(gql) :: Query.t()
  def parse(gql) when is_binary(gql) do
    # tokenize
    # pass to handler based on operation type (query, mutation, subscription)
    # extract resolver tree
    # validate required arguments and argument types
    # verify all leaves are scalars
  end
end
