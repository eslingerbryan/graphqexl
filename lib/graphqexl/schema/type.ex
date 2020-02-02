alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Type do
  @moduledoc """
  GraphQL type
  """

  defstruct(
    deprecated: false,
    deprecation_reason: "",
    description: "",
    fields: %{},
    implements: nil,
    name: ""
  )

  @type t ::
    %Graphqexl.Schema.Type{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      fields: Map.t,
      implements: Ref.t | nil,
      name: String.t
    }

  @doc """
  Lists the fields available on the given `t:Graphqexl.Schema.Type.t/0`.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  @spec fields(Graphqexl.Schema.Type.t):: list(Graphqexl.Schema.Field.t)
  def fields(type) do
    implemented_fields = if is_nil(type.implements) do
      []
    else
      type.implements |> Ref.fields
    end
    type.fields |> Map.keys |> Enum.concat(implemented_fields)
  end

  @doc """
  Checks whether the given field is a custom scalar type.

  Returns: `t:boolean`
  """
  @doc since: "0.1.0"
  @spec is_custom_scalar?(Graphqexl.Schema.Type.t, atom):: boolean
  def is_custom_scalar?(type, field) do
    [:String, :Integer, :Float, :Boolean, :Id] |> type.implements?(field)
  end
end
