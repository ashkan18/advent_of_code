defmodule Day2 do
  def part1 do
    read_input()
    |> Enum.reduce({0, 0}, &update_location/2)
    |> IO.inspect()
  end

  def part2 do
    read_input()
    |> Enum.reduce({0, 0, 0}, &update_location2/2)
    |> IO.inspect()
  end

  defp read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Stream.map(&parse/1)
  end

  defp update_location(["forward", x], {horizontal, depth}), do: {horizontal + x, depth}
  defp update_location(["up", y], {horizontal, depth}), do: {horizontal, depth - y}
  defp update_location(["down", y], {horizontal, depth}), do: {horizontal, depth + y}


  defp update_location2(["forward", x], {horizontal, depth, aim}), do: {horizontal + x, depth + (aim * x), aim}
  defp update_location2(["up", y], {horizontal, depth, aim}), do: {horizontal, depth, aim - y}
  defp update_location2(["down", y], {horizontal, depth, aim}), do: {horizontal, depth, aim + y}

  defp parse([cmd, n]), do: [cmd, String.to_integer(n)]
end

Day2.part1()

Day2.part2()
