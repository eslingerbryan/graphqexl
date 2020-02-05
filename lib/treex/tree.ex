defmodule Treex.Tree do
  defstruct value: nil, children: [], key: nil

  @type t :: %Treex.Tree{value: any, children: [t], key: any}

  @doc """
  Convert the given map into a `t:Treex.Tree.t/0`. If the given map has more than one top-level key,
  the optional `root` parameter specifies what value to give a virtual root node that will be
  inserted at the top of the key and contain the given `map`'s top-level keys as children.

  Returns: `t:Treex.Tree.t/0`
  """
  @doc since: "0.1.0"
  @spec from_map(Map.t):: Treex.Tree.t
  @spec from_map(Map.t, term):: Treex.Tree.t
  def from_map(map, root \\ :root)
  def from_map(map = %{}, root) when map |> map_size == 0,
      do: %Treex.Tree{value: root, children: []}
  def from_map(map = %{}, _root) when map |> map_size == 1,
      do: map |> Enum.reduce(%Treex.Tree{}, &node_from_element/2)
  def from_map(map = %{}, root), do: %{root => map} |> from_map(root)

  @doc false
  defp node_from_element(pair, _), do: pair |> node_from_element
  defp node_from_element({root, children = %{}}) when children |> map_size == 0,
       do: %Treex.Tree{value: root, children: []}
  defp node_from_element({root, children = %{}}),
       do: %Treex.Tree{value: root, children: children |> Enum.map(&node_from_element/1)}
  defp node_from_element({root, children}),
       do: %Treex.Tree{value: root, children: [%Treex.Tree{value: children, children: []}]}
end
