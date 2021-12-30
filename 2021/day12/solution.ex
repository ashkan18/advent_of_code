defmodule Day12 do
  def part1 do
    graph = read_input()
    traverse(graph, graph["start"], ["start"])
    |> Enum.count()
  end

  defp traverse(_graph, [], _visited), do: []

  defp traverse(graph, ["end" | rest], visited),
    do: [visited ++ ["end"]] ++ traverse(graph, rest, visited)

  defp traverse(graph, [check | rest], visited) do
    paths =
      cond do
        check == "start" ->
          []

        lowercased?(check) and check in visited ->
          []

        true ->
          traverse(graph, graph[check], visited ++ [check])
      end

    paths ++ traverse(graph, rest, visited)
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

Day12.part1()
  |> IO.inspect(label: :part1)
