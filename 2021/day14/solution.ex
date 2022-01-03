defmodule Day14 do
  def part1 do
    {input, mapping} = read_input()

    {{_, min}, {_, max}} =
      1..10
      |> Enum.reduce(String.graphemes(input), fn _step, current_result ->
        process_input(current_result, mapping)
      end)
      |> Enum.frequencies()
      |> Enum.sort_by(fn {a, b} -> b end)
      |> Enum.min_max_by(fn {x, y} -> y end)

    abs(max - min)
  end

  def process_input([a | rest], _mapping) when rest == [], do: [a]

  def process_input([a, b | rest], mapping) do
    result = [a, mapping["#{a}#{b}"]]
    result ++ process_input([b] ++ rest, mapping)
  end

  def read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({nil, %{}}, fn line, {input, mapping} ->
      case String.split(line, " -> ") do
        [pattern, to_be_added] ->
          {input, Map.put(mapping, pattern, to_be_added)}

        [initial_input] when initial_input != "" ->
          {initial_input, mapping}

        _ ->
          {input, mapping}
      end
    end)
  end
end

Day14.part1() |> IO.inspect()
