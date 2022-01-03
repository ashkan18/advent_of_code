defmodule QuickSort do
  @doc ~S"""
    Sorts an array using QuickSort.

    ## Examples
      iex> QuickSort.run([5, 3, 4, 1])
      [1, 3, 4, 5]
      iex> QuickSort.run([1, 4, 5, 5])
      [1, 4, 5, 5]
  """
  def run(x) when not is_list(x), do: :no_good
  def run(list), do: quick_sort(list, length(list) - 1)

  defp quick_sort([], _), do: []
  defp quick_sort([a], _), do: [a]
  defp quick_sort(list, pivot_index) do
    pivot_item = Enum.at(list, pivot_index)
    {smaller, duplicate, bigger} = list
      |> Enum.reduce({[], [], []}, fn x, {smaller, duplicate, bigger} ->
        cond do
          x == pivot_item -> {smaller, duplicate ++ [x], bigger}
          x < pivot_item -> {smaller ++ [x], duplicate, bigger}
          x > pivot_item -> {smaller, duplicate, bigger ++ [x]}
        end
      end)
    quick_sort(smaller, length(smaller) - 1) ++ duplicate ++ quick_sort(bigger, length(bigger) - 1)
  end
end
