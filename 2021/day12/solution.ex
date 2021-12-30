defmodule Day12 do
  def part1 do
    graph = read_input()
    traverse(graph, graph["start"], ["start"], [])
  end

  defp traverse(_graph, [], _visited, current_paths), do: current_paths

  defp traverse(graph, ["end" | rest], visited, current_paths),
    do: traverse(graph, rest, visited, current_paths ++ [visited ++ ["end"]])

  defp traverse(graph, [check | rest], visited, current_paths) do
    paths =
      cond do
        check == "start" ->
          current_paths

        lowercased?(check) and check in visited ->
          current_paths

        true ->
          traverse(graph, graph[check], visited ++ [check], current_paths)
      end

    traverse(graph, rest, visited, paths)
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

Day12.part1() |> IO.inspect() |> Enum.count() |> IO.inspect()
