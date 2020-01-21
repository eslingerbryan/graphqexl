alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Query do
  defstruct arguments: [], name: "", fields: %{}, return: %Ref{}

  @type t ::
    %Graphqexl.Schema.Query{
      arguments: Map.t(),
      name: String.t(),
      fields: Map.t(),
      return: Ref.t()
    }
end
