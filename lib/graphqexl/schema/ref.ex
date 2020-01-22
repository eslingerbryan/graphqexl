alias Graphqexl.Schema.{
  Field,
  Interface,
  Type,
  Union
}

defmodule Graphqexl.Schema.Ref do
  @moduledoc """
  Ref struct, representing a connection to another user-defined type
  (that may not yet actually be defined in the run-time context)
  """

  @placeholder %{}

  defstruct :type

  @type t :: %Graphqexl.Schema.Ref{type: atom}
  @type component ::
          Interface.t |
          Type.t |
          Union.t

  @doc """
  Returns a list of the fields available on the type resolved to by the given ref.

  Returns: `[t:Graphqexl.Schema.Field]`
  """
  @doc since: "0.1.0"
  @spec fields(Graphqexl.Schema.Ref.t) :: list(Field.t)
  def fields(ref) do
    case ref.type do
      :Interface -> ref.type |> Interface.fields
      :Type -> ref.type |> Type.fields
      :Union -> ref.type |> Union.fields
      _ -> raise "Unknown ref type! Got: #{ref.type}}"
    end
  end

  @doc """
  Resolves the given `t:Graphqexl.Schema.Ref` into its corresponding `t:Graphqexl.Schema.Ref.component`

  Returns: `t:Graphqexl.Schema.Ref`
  """
  @doc since: "0.1.0"
  @spec resolve(Graphqexl.Schema.Ref.t) :: component
  def resolve(ref) do
    @placeholder |> Map.get(ref.type)
  end
end
