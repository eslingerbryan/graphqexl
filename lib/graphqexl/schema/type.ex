alias Graphqexl.Schema.Interface

defmodule Graphqexl.Schema.Type do
  defstruct(
    deprecated: false,
    deprecation_reason: "",
    description: "",
    fields: [],
    implements: nil,
    name: "",
  )

  @type t ::
    %Graphqexl.Schema.Type{
      deprecated: boolean(),
      deprecation_reason: String.t(),
      description: String.t(),
      fields: Map.t(),
      implements: Interface.t() | nil,
      name: String.t()
    }
end
