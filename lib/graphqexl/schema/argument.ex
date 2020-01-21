alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Argument do
  defstruct name: "", type: %Ref{}

  @type t :: %Graphqexl.Schema.Argument{name: String.t(), type: Ref.t()}
end
