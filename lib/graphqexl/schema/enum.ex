defmodule Graphqexl.Schema.Enum do
  defstruct name: "", values: []

  @type t :: %Graphqexl.Schema.Enum{name: String.t(), values: list(Map.t())}
end
