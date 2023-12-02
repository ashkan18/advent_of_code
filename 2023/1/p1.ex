defmodule P1 do
  def run do
    read_input()
    |> Enum.reduce(0, &calculate_calibration/2)
    |> IO.inspect(label: "Result")

  end

  defp read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
  end

  defp calculate_calibration(line, total_calib) do
    total_calib + digit_of(first_left(line), first_right(line))
  end

  
  defp find_first_digit([a|r]) do
    case Integer.parse(a) do
      :error -> first_left(r)
      {number, _} -> number
    end
  end

  defp first_left(a), do: find_first_digit(String.codepoints(a))
  defp first_right(a), do: first_left(String.codepoints(String.reverse(a)))

  defp digit_of(a,b), do: String.to_integer("#{a}#{b}")
end

P1.run()
