defmodule Day10 do
  require Integer
  @open ["(", "[", "{", "<"]
  @closer_map %{"(" => ")", "[" => "]", "{" => "}", "<" => ">"}
  @opener_map %{")" => "(", "]" => "[", "}" => "{", ">" => "<"}
  @missing_point %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

  def run do
    parsed =
      read_input()
      |> Enum.map(fn cmd -> parse_cmd(cmd, []) end)

    parsed
    |> Enum.reject(fn x -> elem(x, 0) == :incomplete end)
    |> Enum.map(fn {:corrupted, {_expected, got}} -> got end)
    |> Enum.map(&corrupt_point/1)
    |> Enum.sum()
    |> IO.inspect(label: :part1)

    part2_scores =
      parsed
      |> Enum.reject(fn x -> elem(x, 0) == :corrupted end)
      |> Enum.map(fn {:incomplete, missing} ->
        Enum.reduce(missing, 0, fn missing_char, total ->
          total * 5 + @missing_point[@closer_map[missing_char]]
        end)
      end)
      |> Enum.sort()

    Enum.fetch!(part2_scores, div(length(part2_scores), 2))
    |> IO.inspect(label: :part2)
  end

  defp parse_cmd([], []), do: :good_stuff
  defp parse_cmd([], [left | []]), do: {:corrupted, {@closer_map[left], left}}
  defp parse_cmd([], missing = [_left | _]), do: {:incomplete, missing}

  defp parse_cmd([c | rest], read) do
    if c in @open do
      parse_cmd(rest, [c] ++ read)
    else
      expected_opener = @opener_map[c]

      case List.pop_at(read, 0) do
        {^expected_opener, new_read} -> parse_cmd(rest, new_read)
        {expected, _} -> {:corrupted, {@closer_map[expected], c}}
      end
    end
  end

  def corrupt_point(wrong_character) do
    case wrong_character do
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end
  end

  defp read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end
end

Day10.run()
