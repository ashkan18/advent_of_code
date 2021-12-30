defmodule Day12.Part2 do
  def run do
    graph = read_input()
    traverse(graph, graph["start"], ["start"])
    |> Enum.count()
  end

  defp traverse(_graph, [], _visited), do: []

  defp traverse(graph, ["end" | rest], visited),
    do: [visited ++ ["end"]] ++ traverse(graph, rest, visited)

  defp traverse(graph, [node | rest], visited) do
    paths =
      cond do
        node == "start" ->
          []

        lowercased?(node) and node in visited and already_used_small_cave?(visited) ->
          []

        true ->
          traverse(graph, graph[node], visited ++ [node])
      end

    paths ++ traverse(graph, rest, visited)
  end

  defp already_used_small_cave?(visited) do
    visited
    |> Enum.filter(&lowercased?/1)
    |> Enum.frequencies()
    |> Enum.any?(fn {_node, count} -> count > 1 end)
  end

  defp lowercased?(cave), do: String.downcase(cave, :ascii) == cave

  def read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [a, b], current_graph ->
      current_graph
      |> Map.update(a, [b], fn a_nodes -> a_nodes ++ [b] end)
      |> Map.update(b, [a], fn b_nodes -> b_nodes ++ [a] end)
    end)
  end
end

Day12.Part2.run()
  |> IO.inspect(label: :part2)
