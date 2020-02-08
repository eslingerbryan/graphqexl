alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Field,
  Ref,
}

defmodule Graphqexl.Schema.Required do
  @moduledoc """
  Wrapper struct indicating the wrapped type is required on its parent
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:type]
  defstruct [:type]

  @type t :: %Graphqexl.Schema.Required{type: Ref.t}

  @doc """
  Lists the `t:Graphqexl.Schema.Field.t/0`s available on the required type.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  @spec fields(t, Schema.t) :: list(Field.t)
  def fields(required, schema), do: required.type |> Ref.fields(schema)
end
