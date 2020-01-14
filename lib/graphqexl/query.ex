defmodule Graphqexl.Query do
  @type json :: Map.t()
  @type t :: %Graphqexl.Query{operataions: [t]}

  defstruct operations: []

  @spec execute(Query.t()) :: ResultSet.t()
  def execute(query) do
    # build context
    # resolve resolver tree into %ResultSet{}
    # serialize into %Operation{}s
    # return %Query{operations: [<operations>]}
  end

  @spec parse(json) :: Treex.Tree.t()
  def parse(json) do
    # tokenize
    # pass to handler based on operation type (query, mutation, subscription)
    # extract resolver tree
    # validate required arguments and argument types
    # verify all leaves are scalars
  end
end
