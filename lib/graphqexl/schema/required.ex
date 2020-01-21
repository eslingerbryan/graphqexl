alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Required do
  defstruct type: %Ref{}

  @type t :: %Graphqexl.Schema.Required{type: Ref.t()}
end
