defmodule Day13 do
  def part1 do
    {grid, folds} = read_input()
    folds
    |> IO.inspect()
    |> Enum.reduce(grid, &fold/2)
    |> Enum.count()
  end

  defp fold(["x", location], grid) do
    grid
    |> Enum.reduce(%{}, fn {x, y}, grid_after_fold ->
      if x <= location do
        # nothing changes
        Map.put(grid_after_fold, {x, y}, true)
      else
        Map.put(grid_after_fold, {location - (x - location), y}, true)
      end
    end)
  end

  defp fold(["y", location], grid) do
    grid
    |> Enum.reduce(%{}, fn {x, y}, grid_after_fold ->
      if y <= location do
        # nothing changes
        Map.put(grid_after_fold, {x, y}, true)
      else
        Map.put(grid_after_fold, {x, location - (y - location)}, true)
      end
    end)
  end

  def read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({%{}, []}, fn line, {grid, folds} ->
      cond do
        String.starts_with?(line, "fold") ->
          "fold along " <> fold_ins = line
          {grid, folds ++ [String.split(fold_ins, "=")]}
        String.contains?(line, ",") ->
          [x , y]  = String.split(line, ",") |> Enum.map(&String.to_integer/1)
          {Map.put(grid, {x, y}, true), folds}
        true ->
          {grid, folds}
      end
    end)
  end
end

Day13.part1() |> IO.inspect()
