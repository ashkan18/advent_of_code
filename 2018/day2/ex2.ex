defmodule Day2Ex2 do
  def run do
    readInput()
     |> Enum.sort
     |> find_closest()
  end

  def readInput, do: File.open!("input") |> IO.stream(:line)

  def find_closest(list) do
    list
    |> Enum.reduce_while([], fn code, prev_codes ->
          case find_in_list(code, list -- prev_codes) do
            {:found, {first, second}} ->
              IO.puts("Correct box ids: #{first} , #{second}")
              {:halt, {first, second}}
            _ -> {:cont, prev_codes ++ [code] }
          end
        end)
  end

  def find_in_list(_item, []), do: false
  def find_in_list(item, list) do
    [head|tail] = list
    if diff_is_one?(item, head), do: {:found, {item, head}}, else: find_in_list(item, tail)
  end


  def diff_is_one?(a, b) do
    case diff_count(a,b) do
      1 -> {:found, {a, b}}
      _ -> false
    end
  end

  def diff_count(a, b) do
    [a, b]
    |> Enum.map(&String.graphemes/1)
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.reject(fn [a, b] -> a == b end)
    |> Enum.count()
  end
end
