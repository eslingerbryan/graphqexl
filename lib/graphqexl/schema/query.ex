alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Query do
  @moduledoc """
  GraphQL query

  Example:
    type Query {
      getUser(id: Id!): User
      listUsers: [User]
    }
  """
  @moduledoc since: "0.1.0"
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
      arguments: %{atom => term},
      name: String.t,
      return: Ref.t,
    }
end
