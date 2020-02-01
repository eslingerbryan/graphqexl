alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Interface do
  @moduledoc """
  GraphQL Interface, encapsulating a group of fields to be shared between types
  """
  defstruct(
    deprecated: false,
    deprecation_reason: "",
    description: "",
    extend: nil,
    fields: %{},
    name: "",
    on: []
  )

  @type t ::
    %Graphqexl.Schema.Interface{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      name: String.t,
      fields: Map.t,
      on: list(Map.t),
      extend: Ref.t | nil
    }

  @doc """
  Lists the available fields on the given interface.

  Returns: `[t:Graphqexl.Schema.Field.t/0]`
  """
  @doc since: "0.1.0"
  @spec fields(Graphqexl.Schema.Interface.t) :: list(Graphqexl.Schema.Field.t)
  def fields(interface) do
    # TODO: handle extended interfaces
    interface.fields
  end
end
