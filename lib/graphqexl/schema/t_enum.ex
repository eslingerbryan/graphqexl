defmodule Graphqexl.Schema.TEnum do
  @moduledoc """
  GraphQL enum
  """

  defstruct name: "", values: []

  @type t :: %Graphqexl.Schema.TEnum{name: String.t(), values: list(Map.t())}
end
