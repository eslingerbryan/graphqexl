defmodule Graphqexl.Query do
  defstruct operations: []

  def parse(json) do
    # tokenize
    # pass to handler based on operation type (query, mutation, subscription)
    # extract resolver tree
    # verify all leaves are scalars
    # build context
    # resolve resolver tree into %ResultSet{}
    # serialize into %Operation{}s
    # return %Query{operations: [<operations>]}
  end
end
