alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Query do
  @moduledoc """
  GraphQL query
  """

  defstruct(
    arguments: [],
    deprecated: false,
    deprecation_reason: "",
    description: "",
    name: "",
    return: %Ref{}
  )

  @type t ::
    %Graphqexl.Schema.Query{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      arguments: Map.t,
      name: String.t,
      return: Ref.t
    }
end
