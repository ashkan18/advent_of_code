defmodule Day1 do
  def run do
    read_input()
    |> Enum.reduce({nil, 0}, &calculate_speed/2)
    |> IO.inspect()

    read_input()
    |> Stream.chunk_every(3, 1, :discard)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [[left, m1, m2], [m1, m2, right]] -> right > left end)
    |> IO.inspect()
  end

  defp read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  defp calculate_speed(new_depth, {nil, 0}), do: {new_depth, 0}
  defp calculate_speed(new_depth, {previous_depth, total_increase}) do
    if new_depth > previous_depth do
      {new_depth, total_increase + 1}
    else
      {new_depth, total_increase}
    end
  end
end

Day1.run()
