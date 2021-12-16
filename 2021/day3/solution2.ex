defmodule Solution2 do
  def run do
    oxygen = read_input()
      |> oxygen(0)
      |> Enum.join()
      |> Integer.parse(2)
      |> elem(0)
      |> IO.inspect()

    co2 = read_input()
      |> co2(0)
      |> Enum.join()
      |> Integer.parse(2)
      |> elem(0)
      |> IO.inspect()
    IO.inspect(oxygen * co2, label: :result)
  end


  def oxygen([rating], _), do: rating
  def oxygen(list, index) do
    {zero, one} = Enum.reduce(list, {[], []}, fn e, {zero, one} ->
      case Enum.at(e, index) do
        "0" -> {zero ++ [e], one}
        "1" -> {zero, one ++ [e]}
      end
    end)
    if Enum.count(zero) > Enum.count(one) do
      oxygen(zero, index+1)
    else
      oxygen(one, index+1)
    end
  end


  def co2([rating], _), do: rating
  def co2(list, index) do
    {zero, one} = Enum.reduce(list, {[], []}, fn e, {zero, one} ->
      case Enum.at(e, index) do
        "0" -> {zero ++ [e], one}
        "1" -> {zero, one ++ [e]}
      end
    end)
    if Enum.count(one) < Enum.count(zero) do
      co2(one, index + 1)
    else
      co2(zero, index + 1)
    end
  end

  defp read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
  end
end

Solution2.run()
