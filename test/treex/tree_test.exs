alias Treex.Tree

defmodule Treex.TreeTest do
  use ExUnit.Case

  @true_tree_input %{
    top: %{
      child1: "value1",
      child2: 2,
      child3: true
    },
  }
  @expected_true_tree %Tree{
    value: :top,
    children: [
      %Tree{value: :child1, children: [%Tree{value: "value1", children: []}]},
      %Tree{value: :child2, children: [%Tree{value: 2, children: []}]},
      %Tree{value: :child3, children: [%Tree{value: true, children: []}]},
    ],
  }

  @graph_input %{
    top_level1: %{
      nested1: "foo",
      nested2: "bar",
    },
    top_level2: nil,
  }
  @custom_root :custom_root

  @expected_graph %Tree{
    value: :root,
    children: [
      %Tree{
        value: :top_level1,
        children: [
          %Tree{value: :nested1, children: [%Tree{value: "foo", children: []}]},
          %Tree{value: :nested2, children: [%Tree{value: "bar", children: []}]},
        ],
      },
      %Tree{
        value: :top_level2,
        children: [%Tree{value: nil, children: []}],
      },
    ],
  }

  @simple_input %{
    key: "value",
  }
  @expected_simple %Tree{
    value: :key,
    children: [%Tree{value: "value", children: []}],
  }

  @tree %Treex.Tree{
    value: :foo,
    children: [
      %Treex.Tree{value: :bar, children: []},
      %Treex.Tree{
        value: :baz,
        children: [
          %Treex.Tree{value: :qux, children: []},
          %Treex.Tree{
            value: :quux,
            children: [
              %Treex.Tree{value: :quuz, children: []},
              %Treex.Tree{value: :corge, children: []},
            ],
          },
        ],
      },
    ],
  }

  @expected_graph_map %{
    bar: nil,
    baz: %{
      qux: nil,
      quux: %{
        quuz: nil,
        corge: nil,
      },
    },
  }

  @expected_tree_map %{
    foo: @expected_graph_map
  }

  describe "when the input is an empty map" do
    assert %{} |> Tree.from_map == %Tree{value: :root, children: []}
  end

  describe "when the input is a simple one-key / one-level map" do
    test "from_map produces a tree" do
      assert @simple_input |> Tree.from_map == @expected_simple
    end
  end

  describe "when no custom root param is given" do
    test "from_map uses the default root value" do
      assert @graph_input |> Tree.from_map |> Map.get(:value) == :root
    end
  end

  describe "when a custom root param is given" do
    test "from_map uses the given root value" do
      assert @graph_input |> Tree.from_map(@custom_root) |> Map.get(:value) == @custom_root
    end
  end

  describe "when the input is a true tree" do
    test "from_map produces a tree" do
      assert @true_tree_input |> Tree.from_map == @expected_true_tree
    end
  end

  describe "when the input is a graph" do
    test "from_map produces a tree" do
      assert @graph_input |> Tree.from_map == @expected_graph
    end
  end

  test "to_map" do
    assert @tree |> Tree.to_map == @expected_tree_map
  end

  describe "when the tree is empty" do
    test "to_map" do
      assert %Tree{} |> Tree.to_map == %{}
    end
  end

  describe "when pop_root is true" do
    test "to_map" do
      assert @tree |> Tree.to_map(pop_root: true) == @expected_graph_map
    end
  end
end
