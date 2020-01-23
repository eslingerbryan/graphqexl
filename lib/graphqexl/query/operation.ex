alias Graphqexl.Query.ResultSet

defmodule Graphqexl.Query.Operation do
  @moduledoc """
  Individual operation contained in a query
  """

  defstruct name: "", tree: %{}, result: %ResultSet{}

  @type t :: %Graphql.Query.Operation{name: String.t(), tree: Map.t(), result: ResultSet.t()}
end
