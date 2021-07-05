alias Treex.Tree

defmodule Treex.Traverse do
  @moduledoc """
  Basic tree traversal algorithms, implementing depth-first and breadth-first traversal.
  """
  @moduledoc since: "0.1.0"

  @type traverse:: :dfs | :bfs
  @type tree:: Tree.t
  @type history:: [any]
  @type result:: {:continue, any} | {:stop, any}
  @type operation:: (tree, history -> result)
  @type stack::list(tree) | []
  @type queue:: :queue.queue
  @type collection:: stack | queue

  @doc """
  Traverse the given tree and invoke the given operation function on each node.
  The function operation and the algorithm to use (one of `:bfs` or `:dfs`).

  An operation function must have the type:
    `(t:Treex.Tree.t/0, t:Treex.Tree.history -> t:Treex.Tree.result/0)`
  with the form:
    `fn node, history -> body end`
  where `node` is the current node and `history` is the accumulated list of traverse operated nodes.

  Returns: `[t:Treex.Tree.result/0]`

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
  @doc since: "0.1.0"
  @spec traverse(tree, operation, traverse):: history
  def traverse(tree, operation, :bfs), do: tree |> tree_insert(new_queue()) |> bfs(operation, [])
  def traverse(tree, operation, :dfs), do: tree |> tree_insert(new_stack()) |> dfs(operation, [])

  @doc false
  @spec apply_operation(operation, tree, history):: result
  defp apply_operation(operation, node, history) do
    arity = :erlang.fun_info(operation)[:arity]

    if arity != 2 do
      raise "Function #{operation |> inspect} has invalid arity. Expected 3, got #{arity}."
    else
      operation.(node, history)
    end
  end

  @doc false
  @spec bfs(queue, operation, history):: history
  defp bfs({[], []}, _, history), do: history
  defp bfs(queue, operation, history) do
    {{:value, node}, new_queue} = :queue.out(queue)
    new_queue |> next(&bfs/3, node, operation, history)
  end

  @doc false
  @spec dfs(stack, operation, history):: history
  defp dfs(stack, operation, history)
  defp dfs([], _, history), do: history
  defp dfs([node | stack], operation, history), do: stack |> next(&dfs/3, node, operation, history)

  @doc false
  @spec next(collection, function, tree, operation, history):: history
  defp next(collection, named_function, node, operation, history) do
    case apply_operation(operation, node, history) do
      {:continue, res} ->
        node.children
        |> Enum.reduce(collection, &tree_insert/2)
        |> named_function.(operation, [res | history])
      {:stop, res} -> [res | history]
    end
  end

  @doc false
  @spec new_stack:: stack
  defp new_stack, do: []

  @doc false
  @spec new_queue:: queue
  defp new_queue, do: :queue.new

  @doc false
  @spec tree_insert(tree, collection):: collection
  defp tree_insert(tree, collection)
  defp tree_insert(nil, collection), do: collection
  defp tree_insert(tree, stack) when is_list(stack), do: [tree | stack]
  defp tree_insert(tree, queue), do: tree |> :queue.in(queue)
end
