defmodule Graphqexl.Schema.TEnum do
  @moduledoc """
  GraphQL enum
  """

  defstruct name: "", values: [], deprecated: false, deprecation_reason: "", description: ""

  @type t ::
    %Graphqexl.Schema.TEnum{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      name: String.t,
      values: list(atom)
    }

  @doc """
  Lists the values available on the given `t:Graphqexl.Schema.TEnum.t/0`.

  Returns: `[t:atom]`
  """
  @doc since: "0.1.0"
  @spec values(Graphqexl.Schema.TEnum.t) :: list(atom)
  def values(enum) do
    enum.values
  end
end
