defmodule Day9.Part1 do
  def run do
    results =
      read_input()
      |> Enum.reduce(%{low_points: [], previous_line: nil, current_line: nil}, fn next_line, %{ previous_line: previous_line, current_line: current_line, low_points: low_points} ->
        # we always process last_line considering the line before and current line
        # we have to only treat first and last line a bit more especially
        new_low_points = process_low_points(previous_line, current_line, next_line)

        %{
          low_points: low_points ++ new_low_points,
          previous_line: current_line,
          current_line: next_line
        }
      end)

    last_line_results = process_low_points(results.previous_line, results.current_line, nil)

    (results.low_points ++ last_line_results)
    |> Enum.map(&(&1 + 1))
    |> Enum.sum()
  end

  defp process_low_points(previous_line, current_line, next_line) when not is_nil(current_line) do
    current_line
    |> Enum.with_index()
    |> Enum.filter(fn {_element, index} ->
      check_point(index, current_line, previous_line, next_line)
    end)
    |> Enum.map(&elem(&1, 0))
  end
  defp process_low_points(_, _ ,_), do: []

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
