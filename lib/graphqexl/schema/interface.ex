alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Interface do
  @moduledoc """
  GraphQL Interface, encapsulating a group of fields to be shared between types
  """
  defstruct name: "", fields: %{}, on: [], extend: %Ref{}

  @type t ::
    %Graphqexl.Schema.Interface{
      name: String.t(),
      fields: Map.t(),
      on: list(Map.t()),
      extend: Ref.t()
    }
end
