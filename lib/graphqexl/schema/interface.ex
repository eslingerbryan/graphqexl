alias Graphqexl.Schema.{
  Field,
  Ref,
}
alias Treex.Tree

defmodule Graphqexl.Schema.Interface do
  @moduledoc """
  GraphQL Interface, encapsulating a group of `t:Graphqexl.Schema.Field.t/0` to be shared between
  `t:Graphqexl.Schema.Type.t/0`

  Example:
    interface Timestamped {
      createdAt: Datetime
      updatedAt: Datetime
    }
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:name, :fields]
  defstruct [
    :fields,
    :name,
    deprecated: false,
    deprecation_reason: "",
    description: "",
    extend: nil,
    on: []
  ]

  @type t ::
    %Graphqexl.Schema.Interface{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      extend: Ref.t | nil,
      fields: Tree.t,
      name: String.t,
      on: list(Ref.t),
    }

  @doc """
  Lists the available `t:Graphqexl.Schema.Field.t/0`s on the given
  `t:Graphqexl.Schema.Interface.t/0`.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  @spec fields(t):: list(Field.t)
  # TODO: handle extended interfaces
  def fields(interface), do: interface.fields
end
