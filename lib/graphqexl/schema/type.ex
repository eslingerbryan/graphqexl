alias Graphqexl.Schema
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

  @enforce_keys [:name]
  defstruct [
    :name,
    deprecated: false,
    deprecation_reason: "",
    description: "",
    fields: %{},
    implements: nil
  ]

  @type t ::
    %Graphqexl.Schema.Type{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      fields: %{atom => Field.t | [Field.t]},
      implements: Ref.t | nil,
      name: String.t
    }

  @doc """
  Lists the `t:Graphqexl.Schema.Field.t/0`s available on the given `t:Graphqexl.Schema.Type.t/0`.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  @spec fields(t, Schema.t):: list(Field.t)
  def fields(type = %Graphqexl.Schema.Type{implements: nil}, _) do
    # TODO: remove duplication with concat'd version below (and also with interface)
    type.fields
    |> Map.values
    |> Enum.map(&(if &1 |> is_list do &1 |> List.first else &1 end))
  end
  def fields(type = %Graphqexl.Schema.Type{fields: fields}, schema) when map_size(fields) == 0,
      do: type.implements |> Ref.fields(schema)
  def fields(type, schema) do
    type.implements
    |> Ref.fields(schema)
    |> Enum.concat(
         type.fields
         |> Map.values
         |> Enum.map(&(if &1 |> is_list do &1 |> List.first else &1 end))
       )
  end

  @doc """
  Checks whether the given `t:Graphqexl.Schema.Type.t/0` is a custom scalar.

  Returns: `t:boolean/0`
  """
  @doc since: "0.1.0"
  @spec scalar?(t, Schema.t):: boolean
  def scalar?(_ = %Graphqexl.Schema.Type{implements: nil}, _), do: false
  def scalar?(type, schema), do: type.implements |> Ref.scalar?(schema)
end
