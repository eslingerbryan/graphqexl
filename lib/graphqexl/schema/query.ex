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

  @enforce_keys [:name, :return]
  defstruct [
    :name,
    :return,
    arguments: [],
    deprecated: false,
    deprecation_reason: "",
    description: ""
  ]

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
