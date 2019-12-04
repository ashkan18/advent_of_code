defmodule Part1 do
  @range 128392..643281
  def run() do
    @range
    |> Enum.reduce(0, &possible_password?/2)
    |> IO.inspect()
  end

  defp possible_password?(item, current_count) do
    with password_charlist <- Integer.to_charlist(item),
         true <- repeating_char(password_charlist),
         true <- non_decreasing(password_charlist) do
      current_count + 1
    else
      _ -> current_count
    end
  end

  def repeating_char([a, b | c]) when length(c) == 0, do: a == b
  def repeating_char([a, b | c]), do: a == b || repeating_char([b] ++ c)

  def non_decreasing([a, b | c]) when length(c) == 0, do: b >= a
  def non_decreasing([a, b | c]), do: b >= a and non_decreasing([b] ++ c)
end

Part1.run()
