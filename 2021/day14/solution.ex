defmodule Day14 do
  def part1 do
    {input, mapping} = read_input()
    process_input(String.graphemes(input), mapping) |> IO.inspect(label: :one) |> process_input(mapping) |> IO.inspect(label: :two)
    # 0..1
    # |> Enum.reduce(String.graphemes(input), fn _step, current_result ->
    #   process_input(current_result, mapping)
    # end)
    # |> Enum.join()
  end

  def process_input([_a | rest], _mapping) when rest == [], do: []
  def process_input([a, b | rest], mapping) do
    IO.inspect({a, b, mapping["#{a}#{b}"]}, label: :checking)
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
