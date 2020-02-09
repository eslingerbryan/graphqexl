alias Graphqexl.{
  Query,
  Schema,
}

defmodule Graphqexl.Query.Validator do
  @moduledoc """
  Validate a given `t:Graphqexl.Query.t/0` against a given `t:Graphqexl.Schema.t/0`

  Specifically, it checks that:
  1. All leaves are scalar types
  1. All types and fields are defined in the schema
  1. All required arguments are provided
  """
  @moduledoc since: "0.1.0"

  @doc """
  Check whether a query is valid in a given schema

  Returns: `t:boolean.t/0`
  """
  @doc since: "0.1.0"
  @spec valid?(Query.t, Schema.t):: boolean
  def valid?(query, schema) do
    query |> scalar_leaves?(schema) &&
      query |> valid_types_and_fields?(schema) &&
      query |> has_all_required_arguments?(schema)
  end

  @doc false
  @spec has_all_required_arguments?(Query.t, Schema.t):: boolean
  defp has_all_required_arguments?(_query, _schema) do
    # TODO: implement
    true
  end

  @doc false
  @spec scalar_leaves?(Query.t, Schema.t):: boolean
  defp scalar_leaves?(_query, _schema) do
    # TODO: implement
    true
  end

  @doc false
  @spec valid_types_and_fields?(Query.t, Schema.t):: boolean
  defp valid_types_and_fields?(_query, _schema) do
    true
    # TODO: implement as a tree traversal
#    query.fields
#    |> Enum.all?(&(Schema.has_field?(schema, &1)))
  end
end
