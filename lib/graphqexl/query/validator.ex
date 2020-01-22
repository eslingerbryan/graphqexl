alias Graphqexl.{
  Query,
  Schema,
}

defmodule Graphqexl.Query.Validator do
  @moduledoc "Validate a given query against a given schema"

  @doc """
  Check whether a query is valid in a given schema

  Returns: `t:boolean`
  """
  @doc since: "0.1.0"
  @spec valid?(Query.t, Schema.t):: boolean
  def valid?(query, schema) do
    query |> scalar_leaves?(schema) &&
      query |> valid_types_and_fields?(schema) &&
      query |> has_all_required_arguments?(schema)
  end

  @doc false
  defp scalar_leaves?(query, schema) do
    # TODO: implement
    true
  end

  @doc false
  defp valid_types_and_fields?(query, schema) do
    # TODO: implement
    true
  end

  @doc false
  defp has_all_required_arguments?(query, schema) do
    # TODO: implement
    true
  end
end