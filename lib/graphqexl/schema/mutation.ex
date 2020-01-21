alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Mutation do
  defstruct arguments: %{}, name: "", fields: %{}, return: %Ref{}

  @type t ::
    %Graphqexl.Schema.Mutation{
      arguments: Map.t(),
      name: String.t(),
      fields: Map.t(),
      return: Ref.t()
    }
end
