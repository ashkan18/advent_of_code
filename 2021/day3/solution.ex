defmodule Day3 do

  def run do
    {gamma, epsilon} = read_input()
      |> Enum.reduce({[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 0}, &update_numbers/2)
      |> process_results()
      |> IO.inspect()
    IO.inspect(gamma * epsilon)
  end

  def update_numbers(new_number, {current_totals, count}) do
    new_totals = current_totals
      |> Enum.with_index()
      |> Enum.map(fn {element, index} ->
        case String.at(new_number, index) do
          "0" -> element
          "1" -> element + 1
        end
      end)
    {new_totals, count + 1}
  end

  def process_results({counts, total_items}) do
    {gamma, epsilon} = counts
      |> Enum.reduce({[], []}, fn x, {gamma, epsilon} ->
        if x > (total_items / 2) do
          {gamma ++ ["1"], epsilon ++ ["0"]}
        else
          {gamma ++ ["0"], epsilon ++ ["1"]}
        end
      end)
    {bin_list_to_integer(gamma), bin_list_to_integer(epsilon)}
  end

  def bin_list_to_integer(arraylist) do
    arraylist
    |> Enum.join()
    |> Integer.parse(2)
    |> elem(0)
  end

  defp read_input do
    File.open!("input")
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
  end
end


Day3.run()
