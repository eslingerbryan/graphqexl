defmodule Graphqexl.Schema.TEnum do
  @moduledoc """
  GraphQL enum
  """

  defstruct name: "", values: []

  @type t :: %Graphqexl.Schema.TEnum{name: String.t(), values: list(atom)}

  @doc """
  Lists the values available on the given `t:Graphqexl.Schema.TEnum`.

  Returns: `[t:atom]`
  """
  @doc since: "0.1.0"
  @spec values(Graphqexl.Schema.TEnum.t) :: list(atom)
  def fields(enum) do
    enum.values
  end
end
