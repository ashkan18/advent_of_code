defmodule Day11 do
  def part1 do
    grid = read_input()
    Enum.reduce(0..100, {grid, MapSet.new([])} fn step, {grid, []} ->
      make_step(grid, flashes, step)
    end)
  end

  def make_step(grid, flashes, step) do
    grid
    |> Enum.map(fn {{row, col}, energy} -> {{row, col}, energy + 1} end) # increase all energies by one
    |> analyze(step)
  end

  defp analyze([{{row, col}, octupus_energy} | rest], flashes) when octupus_energy = 9 do
    analyze({{row, col}, 0})
  end
  defp anaylyze(grid, flashes), do: {grid, flashes}

  defp read_input do
    file_stream = File.open!("input")
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)

    for {line, row} <- Enum.with_index(file_stream),
        {energy, col} <- Enum.with_index(String.graphemes(line) |> Enum.map(&String.to_integer/1)),
        into: %{} do
      {{row, col}, energy}
    end
  end
end

Day11.part1() |> IO.inspect()
