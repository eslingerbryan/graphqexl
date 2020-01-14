defmodule Treex.Tree do
  defstruct value: nil, children: [], key: nil

  @type t :: %Treex.Tree{value: any, children: [t], key: any}
end
