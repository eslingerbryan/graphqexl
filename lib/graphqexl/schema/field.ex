alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Field do
  defstruct(
    deprecated: false,
    deprecation_reason: "",
    description: "",
    name: "",
    value: %Ref{},
  )

  @type t ::
    %Graphqexl.Schema.Field{
      deprecated: boolean(),
      deprecation_reason: String.t(),
      description: String.t(),
      name: String.t(),
      value: Ref.t()
    }
end
