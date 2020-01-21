defmodule Graphqexl.Schema.Ref do
  @moduledoc """
  Ref struct, representing a connection to another user-defined type
  (that may not yet actually be defined in the run-time context)
  """

  defstruct type: :atom, name: ""

  @type t :: %Graphqexl.Schema.Ref{type: atom(), name: String.t()}
end
