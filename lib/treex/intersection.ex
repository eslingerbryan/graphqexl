alias Treex.{
  Traverse,
  Tree,
}

defmodule Treex.Intersection do
  @moduledoc """
  Implements algorithms for intersecting `t:Treex.Tree.t/0`s and operating on their intersections.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Determine whether a non-empty intersection exists between the given `t:Treex.Tree.t/0` and the
  `other` `t:Treex.Tree.t/0`.

  Returns: `t:boolean/0`
  """
  @doc since: "0.1.0"
  @spec exists?(Tree.t, Tree.t):: boolean
  def exists?(tree, other), do: false

  @doc """
  Compute the intersection between the given `t:Treex.Tree.t/0` and the `other` `t:Treex.Tree.t/0`.
  The result is guaranteed to be a `t:Treex.Tree.t/0`, though possibly an empty tree.

  Returns: `t:Treex.Tree.t/0`
  """
  @doc since: "0.1.0"
  @spec intersection(Tree.t, Tree.t):: Tree.t
  def intersection(tree, other) do
    if tree.value == other.value do
      %{
        tree |
        # TODO: should probably filter by child.value == &1.value just to be sure order doesn't matter
        children: tree.children
                  |> Enum.map(&(&1 |> intersection(other.children |> List.first)))
                  |> Enum.filter(&Tree.any?/1)
      }
    else
      %Tree{value: nil, children: []}
    end
  end
end
