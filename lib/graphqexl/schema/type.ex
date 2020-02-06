alias Graphqexl.Schema.{
  Field,
  Ref,
}
alias Treex.Tree

defmodule Graphqexl.Schema.Type do
  @moduledoc """
  GraphQL custom type

  Example:
    type User {
      id: Id!
      firstName: String
      lastName: String
      email: Email!
    }
  """
  @moduledoc since: "0.1.0"
  defstruct(
    deprecated: false,
    deprecation_reason: "",
    description: "",
    fields: %Tree{},
    implements: nil,
    name: ""
  )

  @type t ::
    %Graphqexl.Schema.Type{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      fields: Tree.t,
      implements: Ref.t | nil,
      name: String.t
    }

  @doc """
  Lists the `t:Graphqexl.Schema.Field.t/0`s available on the given `t:Graphqexl.Schema.Type.t/0`.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  @spec fields(t):: list(Field.t)
  def fields(type) do
    implemented_fields = if is_nil(type.implements) do
      []
    else
      type.implements |> Ref.fields
    end
    type.fields |> Map.keys |> Enum.concat(implemented_fields)
  end

  @doc """
  Checks whether the given `t:Graphqexl.Schema.Field` is a custom scalar type.

  Returns: `t:boolean/0`
  """
  @doc since: "0.1.0"
  @spec is_custom_scalar?(t, atom):: boolean
  def is_custom_scalar?(type, field) do
    [:String, :Integer, :Float, :Boolean, :Id] |> type.implements?(field)
  end
end
