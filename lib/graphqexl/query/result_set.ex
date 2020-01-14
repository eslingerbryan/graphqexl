defmodule Graphqexl.Query.ResultSet do
  defstruct data: %{}, errors: %{}

  @type t :: %Graphql.Query.ResultSet{data: Map.t(), errors: Map.t()}
end
