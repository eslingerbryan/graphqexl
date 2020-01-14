alias Graphqexl.Query.ResultSet

defmodule Graphqexl.Query.Operation do
  defstruct name: "", tree: %{}, result: %ResultSet{}
end
