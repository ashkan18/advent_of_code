defmodule SumOfPairs do

  @doc """

  Finds the first pair of ints as judged by the index of the second value.

  iex> sum_pairs( [ 10, 5, 2, 3, 7, 5 ], 10 )

  { 3, 7 }

  """

  @spec sum_pairs( [ integer ], integer ) :: { integer, integer } | nil

  def sum_pairs( ints, sum ) do
    needs = ints
      |> Stream.with_index()
      |> Enum.reduce(%{}, fn {x, idx}, acc ->
        acc
        |> Map.get_and_update(sum - x, fn current_value -> if current_value == nil, do: {current_value, [idx]}, else: {current_value, current_value ++ [idx]} end)
        |> elem(1)
      end)
      |> IO.inspect()
    ints
    |> Stream.with_index()
    |> Enum.reduce_while({:current_item, :current_minimum_distance}, fn {item, item_idx}, acc ->
      case Map.get(needs, item) do
        nil -> {:cont, acc}
        idxs ->
          idxs
          |> Enum.reject(fn x -> x <= item_idx end)
          |> List.first()
          |>
            case do
              nil -> {:cont, acc}
              idx ->
                case idx - item_idx do
                  1 -> {:halt, item} # can't get any better than this, return
                  distance ->
                    case acc do
                      {:current_item, :current_minimum_distance} ->  {:cont, {item, distance}}# haven't found any yet
                      {_current_item, current_distance} -> if current_distance <= distance, do: {:cont, acc}, else: {:cont, {item, distance}}
                    end
                end
            end
      end
    end)
    |> IO.inspect()
    |> elem(0)
    |> case do
      :current_item -> nil
      item -> {item, sum - item}
    end
  end

end

SumOfPairs.sum_pairs( [ 1, 4, 8, 7, 3, 15 ], 8)
