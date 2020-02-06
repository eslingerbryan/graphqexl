alias Graphqexl.Schema.Ref

defmodule Graphqexl.Schema.Field do
  @moduledoc """
  GraphQL field, belonging to e.g. a `t:Graphqexl.Schema.Type.t/0` or
  `t:Graphqexl.Schema.Interface.t/0`
  """
  @moduledoc since: "0.1.0"
  defstruct(
    deprecated: false,
    deprecation_reason: "",
    description: "",
    name: "",
    value: %Ref{}
  )

  @type t ::
    %Graphqexl.Schema.Field{
      deprecated: boolean,
      deprecation_reason: String.t,
      description: String.t,
      name: String.t,
      value: Ref.t,
    }
end
