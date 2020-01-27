alias Graphqexl.{
  Query,
  Schema,
}
alias Graphqexl.Schema.Type

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
  defp has_all_required_arguments?(_query, _schema) do
    # TODO: implement
    true
  end

  @doc false
  defp is_scalar?(field, schema) do
    cond do
      schema.enums |> Enum.member?(field) -> true
      schema.types |> Enum.member?(field) ->
        schema.types |> Map.get(field) |> Type.is_custom_scalar?(field)
      schema.unions |> Enum.any?(
        &(&1.name == field &&
          (is_scalar?(&1.type1, schema) || is_scalar?(&1.type2, schema)))
      ) -> true
    end
  end

  @doc false
  defp leaves(_tree) do
    []
  end

  @doc false
  defp scalar_leaves?(query, schema) do
    # TODO: implement
    query.fields
    |> leaves
    |> Enum.filter(&(!is_scalar?(&1, schema)))
  end

  @doc false
  defp valid_types_and_fields?(query, schema) do
    query.fields
    |> Enum.all?(&(Schema.has_field?(schema, &1)))
  end
end
