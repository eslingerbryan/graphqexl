alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Subscription do
  @moduledoc """
  GraphQL subscription

  [Not yet fully supported]
  """
  @moduledoc since: "0.1.0"
  defstruct name: "", arguments: %{}, return: %Ref{}

  @type t ::
    %Graphqexl.Schema.Subscription{
      name: String.t,
      arguments: %{atom => term},
      return: Ref.t
    }
end
