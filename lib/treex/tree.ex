defmodule Treex.Tree do
  defstruct value: nil, children: [], key: nil

  @type element:: {term, list(term) | Map.t | term}

  @type t :: %Treex.Tree{value: any, children: [t], key: any}

  @doc """
  List the leaf nodes of the given `t:Treex.Tree.t/0`

  Returns: `[t:Treex.Tree.t/0]`
  """
  @doc since: "0.1.0"
  @spec leaves(t):: list(t)
  def leaves(_tree), do: []

  @doc """
  Convert the given map into a `t:Treex.Tree.t/0`. If the given map has more than one top-level key,
  the optional `root` parameter specifies what value to give a virtual root node that will be
  inserted at the top of the key and contain the given `map`'s top-level keys as children.

  Returns: `t:Treex.Tree.t/0`
  """
  @doc since: "0.1.0"
  @spec from_map(Map.t):: t
  @spec from_map(Map.t, term):: t
  def from_map(map, root \\ :root)
  def from_map(map = %{}, root) when map |> map_size == 0,
      do: %Treex.Tree{value: root, children: []}
  def from_map(map = %{}, _root) when map |> map_size == 1,
      do: map |> Enum.reduce(%Treex.Tree{}, &node_from_element/2)
  def from_map(map = %{}, root), do: %{root => map} |> from_map(root)

  @doc false
  @spec node_from_element(element, term):: t
  @spec node_from_element(element):: t
  defp node_from_element(element)
  defp node_from_element({root, children = %{}}) when children |> map_size == 0,
       do: %Treex.Tree{value: root, children: []}
  defp node_from_element({root, children = %{}}),
       do: %Treex.Tree{value: root, children: children |> Enum.map(&node_from_element/1)}
  defp node_from_element({root, children}),
       do: %Treex.Tree{value: root, children: [%Treex.Tree{value: children, children: []}]}
  defp node_from_element(element, _)
  defp node_from_element(pair, _), do: pair |> node_from_element
end
