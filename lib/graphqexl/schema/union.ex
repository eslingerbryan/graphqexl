alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Union do
  defstruct name: "", type1: %Ref{}, type2: %Ref{}
end
