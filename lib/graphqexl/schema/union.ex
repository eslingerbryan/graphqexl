alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Union do
  @moduledoc """
  GraphQL union
  """

  defstruct name: "", type1: %Ref{}, type2: %Ref{}

  @type t :: %Graphqexl.Schema.Union{name: String.t(), type1: Ref.t(), type2: Ref.t()}
end
