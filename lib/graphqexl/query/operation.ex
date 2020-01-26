alias Graphqexl.Query.ResultSet

defmodule Graphqexl.Query.Operation do
  @moduledoc """
  Individual operation contained in a query
  """

  defstruct(
    arguments: %{},
    fields: %{},
    name: "",
    user_defined_name: "",
    result: %ResultSet{},
    type: :type,
    variables: %{}
  )

  @type t ::
    %Graphqexl.Query.Operation{
      arguments: Map.t,
      fields: Map.t,
      name: String.t,
      user_defined_name: String.t,
      result: ResultSet.t,
      type: atom,
      variables: Map.t
    }

  @doc """
  Add a field with optional nested fields to the given operation

  Returns `t:Graphexl.Query.Operation.t/0`
  """
  @doc since: "0.1.0"
  def add_field(operation, field, nested_fields \\ true) do
    %Graphqexl.Query.Operation{
      operation
      | fields: Map.update(operation.fields, field, nested_fields, &(&1))
    }
  end
end
