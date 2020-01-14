alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Union do
  defstruct name: "", value1: %Ref{}, value2: %Ref{}
end
