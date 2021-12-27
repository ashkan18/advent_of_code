defmodule Day10 do
  require Integer
  @open ["(", "[", "{", "<"]

  def run do
    read_input()
    |> Enum.map(fn cmd -> parse_cmd(cmd, []) end)
    |> Enum.reject(fn x -> x == {:incomplete} end)
    |> Enum.map(fn {:corrupted, {_expected, got}} -> got end)
    |> Enum.map(&point/1)
    |> Enum.sum()
  end

  defp parse_cmd([], []), do: :good_stuff
  defp parse_cmd([], [left | []]), do: {:corrupted, {open_to_close_map(left), left}}
  defp parse_cmd([], [_left | _]), do: {:incomplete}
  defp parse_cmd([c | rest], read) do
    if c in @open do
      parse_cmd(rest, [c] ++ read)
    else
      expected_opener = close_to_open_map(c)
      case List.pop_at(read, 0) do
        {^expected_opener, new_read} -> parse_cmd(rest, new_read)
        {expected, _} -> {:corrupted, {open_to_close_map(expected), c}}
      end
    end
  end

  defp close_to_open_map(")"), do: "("
  defp close_to_open_map("}"), do: "{"
  defp close_to_open_map("]"), do: "["
  defp close_to_open_map(">"), do: "<"
  defp open_to_close_map("("), do: ")"
  defp open_to_close_map("{"), do: "}"
  defp open_to_close_map("["), do: "]"
  defp open_to_close_map("<"), do: ">"

  def point(wrong_character) do
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

Day10.run() |> IO.inspect(label: :part1)
