alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Union do
  @moduledoc """
  GraphQL union
  """

  defstruct name: "", type1: %Ref{}, type2: %Ref{}

  @type t :: %Graphqexl.Schema.Union{name: String.t(), type1: Ref.t(), type2: Ref.t()}

  @doc """
  Lists the fields available on the given `t:Graphqexl.Schema.Union.t/0`.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  @spec fields(Graphqexl.Schema.Union.t):: list(Graphqexl.Schema.Field.t)
  def fields(union) do
    union.type1
      |> Ref.fields
      |> Enum.concat(union.type2 |> Ref.fields)
      |> Enum.uniq
  end
end
