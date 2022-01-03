defmodule Day14 do
  def run do
    {input, mapping} = read_input()

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

Day14.run() |> IO.inspect()
