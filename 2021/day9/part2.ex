defmodule Day9.Part2 do
  def run do

  end

  defp check_point(index, current_line, previous_line, next_line) do
    current_value = Enum.at(current_line, index)
    right = Enum.at(current_line, index + 1)
    left = index > 0 && Enum.at(current_line, index - 1)
    below = not is_nil(next_line) and Enum.at(next_line, index)
    top = not is_nil(previous_line) and Enum.at(previous_line, index)
    Enum.all?([right, left, below, top], fn compare_to -> current_value < compare_to end)
  end

  defp read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end
end

Day9.Part1.run() |> IO.inspect(label: :part1)
