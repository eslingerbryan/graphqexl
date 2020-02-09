alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Field,
  Interface,
  Ref,
  TEnum,
  Type,
  Union,
}
alias Graphqexl.Tokens

defmodule Graphqexl.Schema.Ref do
  @moduledoc """
  Struct holding a reference to a custom `t:Graphqexl.Schema.Ref.component/0`. Used by while parsing
  a `t:Graphqexl.Schema.t/0` because it my refer to a component that has not yet been defined in the
  schema (but will later). A validator (TODO: link to the appropriate validator module) will check
  that all `t:Graphqexl.Schema.Ref`s resolve during the validation step.
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:type]
  defstruct [:type]

  @type built_in:: :Boolean | :Float | :Id | :Integer | :String
  @type component:: built_in | Interface.t | TEnum.t | Type.t | Union.t

  @type t:: %Graphqexl.Schema.Ref{type: atom}

  @doc """
  Returns a list of the `t:Graphqexl.Schema.Field.t/0`s available on the type resolved to by the
  given `t:Graphqexl.Schema.Ref.t/0`.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  def fields(%Ref{type: :Boolean}, _), do: []
  def fields(%Ref{type: :Float}, _), do: []
  def fields(%Ref{type: :Id}, _), do: []
  def fields(%Ref{type: :Integer}, _), do: []
  def fields(%Ref{type: :String}, _), do: []
  @spec fields(t, Schema.t) :: list(Field.t)
  # TODO: fully implement
  def fields(ref, schema) do
    resolved = ref |> Ref.resolve(schema)
    case resolved do
      %Interface{} -> resolved |> Interface.fields(schema)
      %Type{} -> resolved |> Type.fields(schema)
      %Union{} -> resolved |> Union.fields(schema)
      _ -> []
    end
  end

  @doc """
  Resolves the given `t:Graphqexl.Schema.Ref.t/0` into its corresponding
  `t:Graphqexl.Schema.Ref.component/0` according to the given `t:Graphqexl.Schema.t/0`.

  Returns: `t:Graphqexl.Schema.Ref.component/0`
  """
  @doc since: "0.1.0"
  @spec resolve(t, Schema.t) :: component
  def resolve(%Ref{type: :Boolean}, _), do: :Boolean
  def resolve(%Ref{type: :Float}, _), do: :Float
  def resolve(%Ref{type: :Id}, _), do: :Id
  def resolve(%Ref{type: :Integer}, _), do: :Integer
  def resolve(%Ref{type: :String}, _), do: :String
  def resolve(ref, schema) when is_list(ref), do: ref |> List.first |> resolve(schema)
  def resolve(ref, schema) do
    object_type = cond do
      schema.enums |> Map.keys |> Enum.member?(ref.type) -> :enums
      schema.interfaces |> Map.keys |> Enum.member?(ref.type) -> :interfaces
      schema.types |> Map.keys |> Enum.member?(ref.type) -> :types
      schema.unions |> Map.keys |> Enum.member?(ref.type) -> :unions
    end
    schema |> Map.get(object_type) |> Map.get(ref.type)
  end

  @doc """
  Checks whether the given `t:Graphqexl.Schema.Ref.t/0` resolves to a scalar type.

  Returns: `t:boolean/0`
  """
  @doc since: "0.1.0"
  @spec scalar?(t, Schema.t):: boolean
  # TODO: (across the board in scalar checking) handle List types
  # _possibly_ this is where using Elixir's built-in List breaks down, and instead
  # we want a `TList` module, which should definitely implement the Enumerable protocol.
  def scalar?(nil, _), do: false
  def scalar?(ref, schema) do
    ref
    |> resolve(schema)
    |> (&(
      case &1 do
        %Interface{} -> false
        %TEnum{} -> true
        %Type{} -> &1.implements |> scalar?(schema)
        %Union{} ->
          [&1.type1, &1.type2] |> Enum.any?(fn (type) -> type |> scalar?(schema) end)
        _ -> :types |> Tokens.get |> Map.get(:scalar) |> Enum.member?(&1)
      end
    )).()
  end
end
