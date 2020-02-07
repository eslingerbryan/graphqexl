alias Graphqexl.Schema
alias Treex.Tree

defmodule Graphqexl.Query.ResultSet do
  @moduledoc """
  Result of a GraphQL `t:Graphqexl.Query.t/0` operation, including any errors
  """
  @moduledoc since: "0.1.0"
  defstruct data: %{}, errors: %{}

  @type t :: %Graphqexl.Query.ResultSet{data: Map.t, errors: Map.t}

  @doc """
  Filter the given  `t:Graphqexl.Query.ResultSet.t/0` to the `t:Treex.Tree.t/0` of fields specified.

  Returns: `t:Graphqexl.Query.ResultSet.t/0`
  """
  @doc since: "0.1.0"
  @spec filter(t, Tree.t):: t
  # TODO: error handling needs to put info into %{result_set | errors: <info>}
  def filter(result_set, fields), do: %{result_set | data: result_set.data |> filter_data(fields)}

  @doc """
  Validate that a given `t:Graphqexl.Query.ResultSet.t/0` conforms to the given
  `t:Graphqexl.Schema.t/0` and is therefore fine to serialize and return in an HTTP response.

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

  @doc false
  @spec filter_data(Map.t, Tree.t):: Map.t
  defp filter_data(data, fields),
       do: %{fields.value => filter_data_value(data |> Map.get(fields.value), fields.children)}

  @doc false
  @spec filter_data_value(Map.t, list(Tree.t)):: Map.t | list(Map.t | term) | term
  defp filter_data_value(data, []), do: data
  defp filter_data_value(data, children) when is_list(data) do
    data
    |> Enum.map(&(children |> map_filter_data(&1)))
    |> Enum.map(&(&1 |> reduce_merge))
  end
  defp filter_data_value(data, children) do
    children
    |> Enum.map(&(data |> filter_data(&1) |> Enum.into(%{})))
    |> reduce_merge
  end

  @doc false
  @spec map_filter_data(list(term), Map.t):: list(Map.t)
  defp map_filter_data(enum, datum), do: enum |> Enum.map(&(datum |> filter_data(&1)))

  @doc false
  @spec reduce_merge(list(Map.t)):: Map.t
  defp reduce_merge(maps), do: maps |> Enum.reduce(%{}, &(&1 |> Map.merge(&2)))
end
