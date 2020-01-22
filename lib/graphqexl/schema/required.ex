alias Graphqexl.Schema.{
  Field,
  Ref,
}

defmodule Graphqexl.Schema.Required do
  @moduledoc """
  Wrapper struct indicating the wrapped type is required on its parent
  """

  defstruct type: %Ref{}

  @type t :: %Graphqexl.Schema.Required{type: Ref.t()}

  @doc """
  Lists the fields available on the required type.

  Returns: `[t:Graphqexl.Schema.Field]`
  """
  @doc since: "0.1.0"
  @spec fields(Graphqexl.Schema.Required.t) :: list(Graphqexl.Schema.Field)
  def fields(required) do
    required.type |> Ref.fields
  end
end
