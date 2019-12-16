defmodule Travers do
  @tree %TreeNode{
    value: 1,
    left: %TreeNode{
      value: 2,
      right: %TreeNode{value: 5}
    },
    right: %TreeNode{
      value: 3,
      left: %TreeNode{value: 4}
    }
  }
  def run_dfs() do
    @tree
    |> dfs()
    |> IO.inspect()
  end

  def run_bfs() do
    bfs([@tree], [])
    |> IO.inspect()
  end

  defp dfs(:leaf), do: []
  defp dfs(%TreeNode{left: lnode, right: rnode, value: value}), do: [value] ++ dfs(lnode) ++ dfs(rnode)

  defp bfs([], visited), do: visited
  defp bfs([:leaf | r], visited), do: bfs(r, visited)
  defp bfs([node | rest_queue], visited), do: bfs(rest_queue ++ [node.left, node.right], visited ++ [node.value])
end

Travers.run_bfs()
