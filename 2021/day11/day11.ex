defmodule Day11 do
  def part1 do
    grid = read_input()

    Enum.reduce(1..100, {grid, []}, fn _step, {grid, flashes} ->
      {new_grid, flashed} = analyze_step(Map.keys(grid), grid, MapSet.new([]))
      {new_grid, flashes ++ [flashed]}
    end)
    # get flashes
    |> elem(1)
    |> Enum.map(fn step_flashes -> MapSet.size(step_flashes) end)
    |> Enum.sum()
  end

  def part2 do
    grid = read_input()

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while({grid, []}, fn step, {grid, flashes} ->
      {new_grid, flashed} = analyze_step(Map.keys(grid), grid, MapSet.new([]))

      if MapSet.size(flashed) == length(Map.keys(grid)) do
        {:halt, step}
      else
        {:cont, {new_grid, flashes ++ [flashed]}}
      end
    end)
  end

  defp analyze_step([], grid, flashed), do: {grid, flashed}

  defp analyze_step([location = {row, col} | to_check], grid, flashed) do
    value = grid[location]

    cond do
      is_nil(value) or location in flashed ->
        analyze_step(to_check, grid, flashed)

      grid[location] >= 9 ->
        keys = [
          {row - 1, col - 1},
          {row - 1, col},
          {row - 1, col + 1},
          {row, col - 1},
          {row, col + 1},
          {row + 1, col - 1},
          {row + 1, col},
          {row + 1, col + 1}
          | to_check
        ]

        analyze_step(keys, Map.put(grid, location, 0), MapSet.put(flashed, location))

      true ->
        analyze_step(to_check, Map.put(grid, location, value + 1), flashed)
    end
  end

  defp read_input do
    file_stream =
      File.open!("input")
      |> IO.stream(:line)
      |> Enum.map(&String.trim/1)

    for {line, row} <- Enum.with_index(file_stream),
        {energy, col} <-
          Enum.with_index(String.graphemes(line) |> Enum.map(&String.to_integer/1)),
        into: %{} do
      {{row, col}, energy}
    end
  end
end

Day11.part1() |> IO.inspect()

Day11.part2() |> IO.inspect()
