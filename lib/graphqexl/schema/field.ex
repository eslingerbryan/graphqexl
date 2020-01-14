defmodule Graphqexl.Schema.Field do
  defstruct(
    deprecated: false,
    deprectation_reason: "",
    description: "",
    name: "",
    value: %Ref{},
  )
end
