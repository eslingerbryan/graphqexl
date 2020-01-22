defmodule Graphqexl.Query.ResultSet do
  @moduledoc """
  Result of a GraphQL operation, including any errors
  """

  defstruct data: %{}, errors: %{}

  @type t :: %Graphql.Query.ResultSet{data: Map.t(), errors: Map.t()}
end
