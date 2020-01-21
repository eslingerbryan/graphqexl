defmodule Graphqexl.Schema.Subscription do
  @moduledoc """
  GraphQL subscription
  """
  defstruct name: "", fields: %{}

  @type t :: %Graphqexl.Schema.Subscription{name: String.t(), fields: Map.t()}
end
