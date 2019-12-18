defmodule LongestCommon do
  def run(words) when is_list(words) do
    min_length = words
      |> Enum.map(&String.length/1)
      |> Enum.min()

    0..min_length
    |> Enum.reduce_while("", fn idx, str ->
      chars = words
      |> Enum.map(&(String.at(&1, idx)))
      |> Enum.uniq()
      case length(chars) do
        1 -> {:cont, str <> List.first(chars)}
        _ -> {:halt, str}
      end
    end)
    |> IO.inspect()
  end
end

LongestCommon.run(["dog","racecar","car"])
