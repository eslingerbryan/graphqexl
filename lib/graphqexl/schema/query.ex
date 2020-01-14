alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Query do
  defstruct arguments: [], name: "", return: %Ref{}
end
