defmodule Treex.Traverse do
  @moduledoc """
    Basic tree traversal algoritms.
    It implements depth-first and breadth-first traverse algorithms
  """
  alias Treex.Tree

  @type traverse() :: :dfs | :bfs
  @type tree() :: Tree.t()
  @type history() :: [any]
  @type result() :: {:continue, any} | {:stop, any}
  @type operation() :: (any, any, history -> result)
  @type stack() :: [tree] | []
  @type queue() :: :queue.queue()
  @type collection() :: stack | queue

  @doc """
    Main function. You need to pass the tree structure,
    the function operation and the algorithm to use.
    An operation function must have the type: (any, any, history -> result)
    with the form: fn value, key, history -> body end
    where value and key are the node's values and keys, and
    history is the accumulated list of traverse operated nodes.

    Returns list with the result of the operation on each node

  ## Examples
   iex> Treex.TreeTraversal.traverse(nil, fn x, _, _ -> {:continue, x} end, :bfs)
   []

   iex> Treex
   ..(1)> .Traverse
   ..(1)> .traverse(%Treex.Tree{value: 1,
   ..(1)>                             children: [%Treex.Tree{value: 2}, 
   ..(1)>                                        %Treex.Tree{value: 3},
   ..(1)>                                        %Treex.Tree{value: 4}]},
   ..(1)>                               fn x, _, _ -> {:continue, x} end,
   ..(1)>                             :bfs)
    [4, 3, 2, 1]
  """
  @spec traverse(tree, operation, traverse) :: history
  def traverse(tree, operation, type)
  def traverse(tree, operation, type) do
    case type do
      :dfs ->
        new_stack() |> tree_insert(tree) |> dfs(operation, [])

      :bfs ->
        new_queue() |> tree_insert(tree) |> bfs(operation, [])
    end
  end

  @spec dfs(stack, operation, history) :: history
  defp dfs(stack, operation, history)
  defp dfs([], _, history), do: history
  defp dfs([%Tree{value: value, key: key, children: children} | stack], operation, history) do
    next(&dfs/3, stack, value, key, children, operation, history)
  end

  @spec bfs(queue, operation, history) :: history
  defp bfs(queue, operation, history)
  defp bfs({[], []}, _, history), do: history
  defp bfs(queue, operation, history) do
    {{:value, %Tree{value: value, key: key, children: children}}, new_queue} = :queue.out(queue)
    next(&bfs/3, new_queue, value, key, children, operation, history)
  end

  @spec tree_insert(collection, tree) :: collection
  defp tree_insert(collection, tree)
  defp tree_insert(collection, nil), do: collection
  defp tree_insert(stack, tree) when is_list(stack), do: [tree | stack]
  defp tree_insert(queue, tree), do: :queue.in(tree, queue)

  @spec next(function, collection, any, any, [tree], operation, history) :: history
  defp next(named_function, collection, value, key, children, operation, history) do
    case apply_operation(operation, value, key, history) do
      {:stop, res} ->
        [res | history]

      {:continue, res} ->
        children
        |> Enum.reduce(
             collection,
             fn tree, acc ->
               tree_insert(acc, tree)
             end
           )
        |> named_function.(operation, [res | history])
    end
  end

  @spec apply_operation(operation, any, any, history) :: result
  defp apply_operation(operation, value, key, history) do
    arity = :erlang.fun_info(operation)[:arity]

    if arity != 3 do
      raise "Function #{operation} has invalid arity.
              Expected 3, got #{arity}."
    else
      operation.(value, key, history)
    end
  end

  @spec new_stack() :: stack
  defp new_stack, do: []

  @spec new_queue() :: queue
  defp new_queue, do: :queue.new()
end
