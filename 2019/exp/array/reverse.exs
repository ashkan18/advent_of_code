defmodule Reverse do
  def run(str) do
    str
    |> String.to_charlist()
    |> reverse()
    |> IO.inspect()
  end

  defp reverse([]), do: []
  defp reverse([head|tail]) when tail == [], do: [head]
  defp reverse(str) do
    first = List.first(str)
    last = List.last(str)
    rest = str
    |> Enum.drop(1)
    |> Enum.drop(-1)
    [last] ++ reverse(rest) ++ [first]
  end
end

Reverse.run("ashkan")
