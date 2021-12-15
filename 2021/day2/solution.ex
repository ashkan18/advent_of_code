defmodule Day2 do
  def run do
    read_input()
    |> Enum.reduce({0, 0}, &update_location/2)
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

  defp parse([cmd, n]), do: [cmd, String.to_integer(n)]
end

Day2.run()
