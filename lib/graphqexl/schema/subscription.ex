alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Subscription do
  @moduledoc """
  GraphQL subscription
  """
  defstruct name: "", arguments: %{}, return: %Ref{}

  @type t ::
    %Graphqexl.Schema.Subscription{
      name: String.t(),
      arguments: Map.t,
      return: Ref.t
    }
end
