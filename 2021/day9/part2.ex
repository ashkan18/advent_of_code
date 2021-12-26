defmodule Day9.Part2 do
  def run do
    grid = read_grid()
    grid
    |> low_points()
    |> Enum.map(fn {{row, col}, _} ->
      basin({row, col}, grid)
      |> MapSet.size()
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def low_points(grid) do
    grid
    |> Enum.filter(fn {{i, j}, number} ->
      left = grid[{i - 1, j}]
      right = grid[{i + 1, j}]
      top = grid[{i, j - 1}]
      bottom = grid[{i, j + 1}]
      number < left and number < right and number < top and number < bottom
    end)
  end


  def basin(point, grid) do
    basin(MapSet.new(), point, grid)
  end

  def basin(set, {row, col} = point, grid) do
    if point in set or grid[point] in [9, nil] do
      set
    else
      set
      |> MapSet.put(point)
      |> basin({row - 1, col}, grid)
      |> basin({row + 1, col}, grid)
      |> basin({row, col - 1}, grid)
      |> basin({row, col + 1}, grid)
    end
  end

  defp read_grid do
    lines = File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)

    for {line, row} <- Enum.with_index(lines),
      {number, column} <- Enum.with_index(String.to_charlist(line)),
      into: %{} do
        {{row, column}, number - ?0}
      end
  end
end

Day9.Part2.run() |> IO.inspect(label: :part2)
