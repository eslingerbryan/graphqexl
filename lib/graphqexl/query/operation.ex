alias Graphqexl.Query.ResultSet
alias Treex.Tree

defmodule Graphqexl.Query.Operation do
  @moduledoc """
  Individual operation contained in a query
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:fields, :name, :type]
  defstruct [
    :fields,
    :name,
    :type,
    arguments: %{},
    result: %ResultSet{},
    user_defined_name: "",
    variables: %{}
  ]

  @type t::
    %Graphqexl.Query.Operation{
      arguments: Map.t,
      fields: Tree.t,
      name: String.t,
      user_defined_name: String.t,
      result: ResultSet.t,
      type: atom,
      variables: Map.t,
    }
end
