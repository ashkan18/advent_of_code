defmodule Day9 do

  def part1 do
    read_input()
    |> Enum.reduce(%{low_points: [], two_lines_before: nil, last_line: nil}, fn current_line, current_state ->
      # we always process last_line considering the line before and current line
      # we have to only treat first and last line a bit more especially
      new_low_points = process_low_points(current_state.two_lines_before, current_state.last_line, current_line)
      %{low_points: current_state.low_points ++ new_low_points, two_lines_before: current_state.last_line ,last_line: current_line}
    end)
  end

  defp process_low_points(nil, nil, _line) do
    []
  end
  defp process_low_points(nil, first_line, second_line) do
    # this is the case for the first line
    width = length(first_line)
    for i <- 0..length(first_line), into: [] do
      if check_point(i, first_line, second_line), do: Enum.at(first_line, i)
    end
  end
  defp process_low_points(_first_line, _second_line, _third_line) do
    []
  end

  defp check_point(x, target_line, compare_line) do
    current_value = Enum.at(target_line, x)
    right = Enum.at(target_line, x + 1)
    left = Enum.at(target_line, x - 1)
    below = Enum.at(compare_line, x)
    Enum.all?([right, left, below], fn compare_to -> current_value < compare_to end)
  end

  defp read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end
end

Day9.part1() |> IO.inspect()
