alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Interface do
  defstruct name: "", fields: %{}, on: [], extend: %Ref{}

  @type t ::
    %Graphqexl.Schema.Interface{
      name: String.t(),
      fields: Map.t(),
      on: list(Map.t()),
      extend: Ref.t()
    }
end
