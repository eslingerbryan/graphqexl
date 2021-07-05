alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Argument do
  @moduledoc """
  GraphQL argument, belonging to e.g. a Query or Mutation
  """

  @enforce_keys [:name, :type]
  defstruct [
    :name,
    :type,
    deprecated: false,
    deprecation_reason: "",
    description: "",
    required: false
  ]

  @type t ::
    %Graphqexl.Schema.Argument{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      name: String.t,
      required: boolean,
      type: Ref.t
    }
end
