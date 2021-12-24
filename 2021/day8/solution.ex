defmodule Solution do
  def run do
    input = read_input()
    input
    |> part1()
    |> IO.inspect(label: :part1)

    input
    |> part2()
    |> IO.inspect(label: :part2)
  end

  def part1(input) do
    input
    |> Enum.map(fn [_segment, output] ->
      Enum.count(output, fn item ->
        byte_size(item) in [2, 4, 3, 7]
      end)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp parse(entry) do
    [segment | [output |_]] = entry
    group_by_length = Enum.group_by(segment, &String.length/1)
    found = %{
      "1" => List.first(group_by_length[2]),
      "4" => List.first(group_by_length[4]),
      "7" => List.first(group_by_length[3]),
      "8" => List.first(group_by_length[7])
    }
    found = process_6(found, group_by_length[6])
    found = process_5(found, group_by_length[5])
    code_digit_map = Map.new(found, fn {key, val} -> {val, key} end)

    read_output(code_digit_map, output)
  end

  defp process_6(found = %{"1" => one, "4" => four}, sixes) do
    six = Enum.find(sixes, &(check_common_chars(&1, one, 1)))
    zero = Enum.find(sixes, fn item ->
      check_diff_chars(four, item, 1) && item != six
    end)
    nine = List.first(sixes -- [six, zero])
    Map.merge(found, %{"6" => six, "0" => zero, "9" => nine})
  end

  defp process_5(found = %{"1" => one, "4" => four}, fives) do
    three = Enum.find(fives, &(check_common_chars(&1, one, 2)))
    two = Enum.find(fives, &(check_common_chars(&1, four, 2)))
    five = List.first(fives -- [three, two])
    Map.merge(found, %{"3" => three, "2" => two, "5" => five})
  end

  defp check_common_chars(a, b, number) do
    length(Enum.filter(String.graphemes(a), fn x -> x in String.graphemes(b) end)) == number
  end

  defp check_diff_chars(a, b, number) do
    diff = MapSet.new(String.graphemes(a))
      |> MapSet.difference(MapSet.new(String.graphemes(b)))
      MapSet.size(diff) == number
  end

  defp read_output(code_digit_map, output) do
    output
    |> Enum.map(fn x ->
        Enum.find(code_digit_map, fn {code, _digit} ->
          MapSet.equal?(MapSet.new(String.graphemes(code)), MapSet.new(String.graphemes(x)))
        end)
        |> elem(1)
    end)
    |> Enum.join()
  end

  defp read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&(String.split(&1, "|", trim: true)))
    |> Enum.map(fn entry ->
      Enum.map(entry, &(String.split(&1, " ", trim: true)))
    end)

  end
end

Solution.run()
