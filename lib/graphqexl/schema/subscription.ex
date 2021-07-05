alias Graphqexl.Schema.{
  Argument,
  Ref,
}

defmodule Graphqexl.Schema.Subscription do
  @moduledoc """
  GraphQL subscription

  [Not yet fully supported]
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:name, :return]
  defstruct [:name, :return, arguments: %{}]

  @type t ::
    %Graphqexl.Schema.Subscription{
      name: String.t,
      arguments: %{atom => Argument.t},
      return: Ref.t
    }
end
