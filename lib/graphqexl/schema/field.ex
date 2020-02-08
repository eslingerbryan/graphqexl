alias Graphqexl.Schema
alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Field do
  @moduledoc """
  GraphQL field, belonging to e.g. a `t:Graphqexl.Schema.Type.t/0` or
  `t:Graphqexl.Schema.Interface.t/0`.
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:name, :value]
  defstruct [:name, :value, deprecated: false, deprecation_reason: "", description: ""]

  @type t::
    %Graphqexl.Schema.Field{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      name: String.t,
      value: Ref.t,
    }

  @doc """
  Checks whether the given `t:Graphqexl.Schema.Field` is a scalar.

  Returns: `t:boolean/0`
  """
  @doc since: "0.1.0"
  @spec scalar?(t, Schema.t):: boolean
  def scalar?(field, schema), do: field.value |> Ref.scalar?(schema)
end
