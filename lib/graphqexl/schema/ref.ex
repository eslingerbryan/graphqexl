defmodule Graphqexl.Schema.Ref do
  defstruct type: :atom, name: ""

  @type t :: %Graphqexl.Schema.Ref{type: atom(), name: String.t()}
end
