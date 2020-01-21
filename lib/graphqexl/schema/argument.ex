alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Argument do
  @moduledoc """
  GraphQL argument, belonging to e.g. a Query or Mutation
  """

  defstruct name: "", type: %Ref{}

  @type t :: %Graphqexl.Schema.Argument{name: String.t(), type: Ref.t()}
end
