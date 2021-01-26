alias Treex.{
  Intersection,
  Tree,
}

defmodule Treex.IntersectionTest do
  use ExUnit.Case

  @tree_a %Tree{
    value: :foo,
    children: [
      %Tree{
        value: :bar,
        children: [
          %Tree{value: :baz, children: []},
          %Tree{value: :qux, children: []},
        ]
      },
      %Tree{
        value: :quux,
        children: []
      }
    ]
  }

  @tree_b %Tree{
    value: :foo,
    children: [
      %Tree{
        value: :baz,
        children: [%Tree{value: :bar, children: []}]
      },
      %Tree{
        value: :qux,
        children: []
      }
    ]
  }

  @full_disjoint_tree %Tree{
    value: "foo",
    children: [
      %Tree{
        value: "bar",
        children: [
          %Tree{value: "baz", children: []},
          %Tree{value: "qux", children: []},
        ]
      },
      %Tree{
        value: "quux",
        children: []
      }
    ]
  }

  @subtree_a %Tree{
    value: :foo,
    children: [
      %Tree{
        value: :bar,
        children: [
          %Tree{value: :baz},
        ]
      },
      %Tree{
        value: :qux,
        children: [%Tree{value: :quux, children: []}]
      }
    ]
  }

  @empty_tree %Tree{value: nil, children: []}

  describe "when the trees are disjoint" do
    test "intersection is an empty tree" do
      assert @tree_a |> Intersection.intersection(@full_disjoint_tree) == @empty_tree
    end
  end

  describe "when the trees share only a root" do
    test "intersection is a single node" do
      assert @tree_a |> Intersection.intersection(@tree_b) == %Tree{value: :foo, children: []}
    end
  end

  describe "when one tree is a subtree of the other" do
    test "intersection is the overlapping nodes" do
      expected = %Tree{
        value: :foo,
        children: [
          %Tree{
            value: :bar,
            children: [
              %Tree{value: :baz, children: []}
            ]
          }
        ]
      }
      assert @tree_a |> Intersection.intersection(@subtree_a) == expected
    end
  end
end
