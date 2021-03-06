defmodule Day1 do
  def run do
    read_input()
    |> Stream.map(&calculate_fuel/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp read_input, do: File.open!("data") |> IO.stream(:line)

  defp calculate_fuel(mass) when is_binary(mass) do
    mass
    |> String.trim()
    |> String.to_integer()
    |> calculate_fuel()
  end

  defp calculate_fuel(mass) when is_integer(mass) do
    mass
    |> div(3)
    |> floor()
    |> Kernel.-(2)
  end
end

Day1.run()
