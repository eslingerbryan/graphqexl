alias Graphqexl.Schema

defmodule Graphqexl.Query.ResultSet do
  @moduledoc """
  Result of a GraphQL operation, including any errors
  """
  @moduledoc since: "0.1.0"
  defstruct data: %{}, errors: %{}

  @type t :: %Graphqexl.Query.ResultSet{data: Map.t, errors: Map.t}

  @doc """
  Validate that a given `t:Graphqexl.Query.ResultSet.t/0` conforms to the given schema and is
  therefore fine to serialize and return in a query response.

  Returns: `t:Graphqexl.Query.ResultSet.t/0` (for chainability)
  """
  @doc since: "0.1.0"
  @spec validate!(t, Schema.t):: t
  # recurse through the entire result_set and check that the values are coercible into the types
  # specified in the given schema. if any are not, set them to nil in the data field and add an
  # appropriate error in the error field (for now, can implement the error rendering in this module,
  # but will eventually probably warrant its own module
  # TODO: real implementation
  def validate!(result_set, _schema), do: result_set
end
