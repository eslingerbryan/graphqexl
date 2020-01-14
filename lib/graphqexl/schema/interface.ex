alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Interface do
  defstruct name: "", fields: [], on: [], extend: %Ref{}
end
