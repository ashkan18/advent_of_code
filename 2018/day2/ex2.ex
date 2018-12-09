defmodule Day2Ex2 do
  def run do
    readInput()
     |> Enum.sort
     |> find_correct()
  end

  defp readInput, do: File.open!("input") |> IO.stream(:line)

  # Find correct box ids from from a list of box ids
  defp find_correct([]), do: IO.puts("Could not find correct boxes.")
  defp find_correct([head|tail]) do
    case(find_in_list(head, tail)) do
      {:found, {box1, box2}} -> IO.puts("Correct box ids: #{box1} , #{box2}")
      _ -> find_correct(tail)
    end
  end

  # Find possible corrects for this box id
  defp find_in_list(_box_id, []), do: false
  defp find_in_list(box_id, [head|tail]) do
    if diff_is_one?(box_id, head), do: {:found, {box_id, head}}, else: find_in_list(box_id, tail)
  end


  defp diff_is_one?(a, b), do: diff_count(a,b) == 1

  defp diff_count(a, b) do
    [a, b]
    |> Enum.map(&String.graphemes/1)
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.reject(fn [a, b] -> a == b end)
    |> Enum.count()
  end
end
