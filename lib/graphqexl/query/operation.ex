alias Graphqexl.Query.ResultSet

defmodule Graphqexl.Query.Operation do
  defstruct name: "", tree: %{}, result: %ResultSet{}

  @type t :: %Graphql.Query.Operation{name: String.t(), tree: Map.t(), result: ResultSet.t()}
end
