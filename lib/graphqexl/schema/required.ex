alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Required do
  @moduledoc """
  Wrapper struct indicating the wrapped type is required on its parent
  """

  defstruct type: %Ref{}

  @type t :: %Graphqexl.Schema.Required{type: Ref.t()}
end
