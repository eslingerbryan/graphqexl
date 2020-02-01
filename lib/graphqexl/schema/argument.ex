alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Argument do
  @moduledoc """
  GraphQL argument, belonging to e.g. a Query or Mutation
  """

  defstruct(
    deprecated: false,
    deprecation_reason: "",
    description: "",
    name: "",
    type: %Ref{}
  )

  @type t ::
    %Graphqexl.Schema.Argument{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      name: String.t,
      type: Ref.t
    }
end
