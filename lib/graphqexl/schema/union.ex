alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Field,
  Ref,
}

defmodule Graphqexl.Schema.Union do
  @moduledoc """
  GraphQL union type

  Example:
    union Content = Comment | Post
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:name, :type1, :type2]
  defstruct [:name, :type1, :type2, deprecated: false, deprecation_reason: "", description: ""]

  @type t ::
    %Graphqexl.Schema.Union{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      name: String.t,
      type1: Ref.t,
      type2: Ref.t,
     }

  @doc """
  Lists the `t:Graphqexl.Schema.Field.t/0`s available on the given `t:Graphqexl.Schema.Union.t/0`.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  @spec fields(t, Schema.t):: list(Field.t)
  def fields(union, schema) do
    union.type1
    |> Ref.fields(schema)
    |> Enum.concat(union.type2 |> Ref.fields(schema))
    |> Enum.uniq
  end
end
