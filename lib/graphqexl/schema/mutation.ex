alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Mutation do
  @moduledoc """
  GraphQL mutation

  Example:
    type Mutation {
      createUser(firstName: String, lastName: String, email: Email!): User
    }
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:name, :return]
  defstruct [
    :name,
    :return,
    arguments: %{},
    deprecated: false,
    deprecation_reason: "",
    description: ""
  ]

  @type t ::
    %Graphqexl.Schema.Mutation{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      arguments: %{atom => term},
      name: String.t,
      return: Ref.t
    }
end
