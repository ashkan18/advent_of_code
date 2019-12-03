defmodule Part1 do
  def run() do
    read_input()
    |> find_combo(0, 0, MapSet.new(["00"]))
  end

  defp read_input, do: File.open!("data") |> IO.binread(:all) |> String.split(",") |> Enum.map(&String.to_integer/1)

  defp find_combo(code, input1, input2, seen_already) do
    code
    |> List.update_at(1, fn _x -> input1 end)
    |> List.update_at(2, fn _x -> input2 end)
    |> run_code()
    |> verify_or_continue(code, input1, input2, seen_already)
  end

  defp verify_or_continue(19690720, _code, input1, input2, _seen_already), do: IO.puts("#{input1} and #{input2} is the combo: #{100 * input1 + input2}")
  defp verify_or_continue(_, code, _input1, _input2, seen_already) do
    case get_random_input(seen_already) do
      {:found, {i, j}} -> find_combo(code, i, j, MapSet.put(seen_already, "#{i}#{j}"))
      {:nope} -> IO.puts("no input can be found")
    end
  end

  defp get_random_input(seen_already) when map_size(seen_already) == 99 * 99, do: {:nope}
  defp get_random_input(seen_already) do
    i = :rand.uniform(99)
    j = :rand.uniform(99)
    case MapSet.member?(seen_already, "#{i}#{j}") do
      true -> get_random_input(seen_already)
      false -> {:found, {i, j}}
    end
  end

  defp run_code(code) do
    code
    |> Enum.chunk_every(4)
    |> Enum.reduce_while(code, &process_line/2)
    |> Enum.at(0)
  end

  defp process_line([1, a, b, loc], code), do: {:cont, List.update_at(code, loc, fn _x -> Enum.at(code, a) + Enum.at(code, b) end)}
  defp process_line([2, a, b, loc], code), do: {:cont, List.update_at(code, loc, fn _x -> Enum.at(code, a) * Enum.at(code, b) end)}
  defp process_line([99 | _], code), do: {:halt, code}
  defp process_line(_, _), do: {:halt, ["Unknown code"]}
end

Part1.run()
