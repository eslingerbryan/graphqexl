alias Graphqexl.Schema.{
  Field,
  Interface,
  Type,
  Union,
}

defmodule Graphqexl.Schema.Ref do
  @moduledoc """
  Ref struct, representing a connection to another user-defined type
  (that may not yet actually be defined in the run-time context)
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:type]
  defstruct [:type]

  @type component:: Interface.t | Type.t | Union.t

  @type t:: %Graphqexl.Schema.Ref{type: atom}

  @placeholder %{}

  @doc """
  Returns a list of the `t:Graphqexl.Schema.Field.t/0`s available on the type resolved to by the
  given `t:Graphqexl.Schema.Ref.t/0`.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  @spec fields(t) :: list(Field.t)
  def fields(ref) do
    case ref.type do
      :Interface -> ref.type |> Interface.fields
      :Type -> ref.type |> Type.fields
      :Union -> ref.type |> Union.fields
      _ -> raise "Unknown ref type! Got: #{ref.type}}"
    end
  end

  @doc """
  Resolves the given `t:Graphqexl.Schema.Ref.t/0` into its corresponding
  `t:Graphqexl.Schema.Ref.component/0`.

  Returns: `t:Graphqexl.Schema.Ref.component/0`
  """
  @doc since: "0.1.0"
  @spec resolve(t) :: component
  # TODO: fully implement
  def resolve(ref), do: @placeholder |> Map.get(ref.type)
end
