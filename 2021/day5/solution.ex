defmodule Reader do
  def read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
  end
end

defmodule Solution do
  def run do
    Reader.read_input()
    |> Stream.map(&parse/1)
    |> Enum.reduce(%{}, &check_direction/2)
    |> Enum.count(fn {_k, v} -> v > 1 end)
    |> IO.inspect()
  end

  def parse(row) do
    row
    |> String.split(" -> ")
    |> Enum.map(fn directions ->
      directions
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def check_direction([[x, y1],[x, y2]], current_map) do
    y1..y2
    |> Enum.reduce(current_map, fn col, current ->
      current
      |> Map.update("#{x}_#{col}", 1, &(&1 + 1))
    end)
  end

  def check_direction([[x1, y],[x2, y]], current_map) do
    x1..x2
    |> Enum.reduce(current_map, fn row, current ->
      current
      |> Map.update("#{row}_#{y}", 1, &(&1 + 1))
    end)
  end

  # comment out this function for part1
  def check_direction([[x1, y1], [x2, y2]], current_map) when abs(x1 - x2) == abs(y1 - y2) do
    Enum.zip(x1..x2, y1..y2)
    |> Enum.reduce(current_map, fn {i, j}, current_map ->
      Map.update(current_map, "#{i}_#{j}", 1, &(&1 + 1))
    end)
  end

  def check_direction(_, current_map), do: current_map
end

Solution.run()
