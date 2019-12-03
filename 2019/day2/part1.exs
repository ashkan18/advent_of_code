defmodule Part1 do
  def run() do
    read_input()
    |> run_code()
  end

  defp read_input, do: File.open!("data") |> IO.binread(:all) |> String.split(",") |> Enum.map(&String.to_integer/1)

  defp run_code(code) do
    code
    |> Enum.chunk_every(4)
    |> Enum.reduce_while(code, &process_line/2)
    |> Enum.at(0)
    |> IO.inspect()
  end

  defp process_line([1, a, b, loc], code), do: {:cont, List.update_at(code, loc, fn _x -> Enum.at(code, a) + Enum.at(code, b) end)}
  defp process_line([2, a, b, loc], code), do: {:cont, List.update_at(code, loc, fn _x -> Enum.at(code, a) * Enum.at(code, b) end)}
  defp process_line([99 | _], code), do: {:halt, code}
  defp process_line(_, _), do: {:halt, ["Unknown code"]}
end

Part1.run()
