defmodule Solution do
  def run1 do
    {min, max, point_frequencies} = read_input()
    min..max
    |>
      Enum.reduce({nil, nil}, fn {point, _}, current_best ->
        check(point, point_frequencies, current_best, &part1_calculator/2)
      end)
      |> IO.inspect()
  end

  def run2 do
    {min, max, point_frequencies} = read_input()

    min..max
    |> Enum.reduce({nil, nil}, fn check_point, current_best ->
      check(check_point, point_frequencies, current_best, &part2_calculator/2)
    end)
    |> IO.inspect()
  end

  def check(point, point_frequencies, {current_best_point, current_best}, calc_fun) do
    point_frequencies
    |> Enum.reduce_while(0, fn {check_point, times_repeated}, current_fuel_needed ->
      current_fuel_needed = current_fuel_needed + calc_fun.(check_point, point) * times_repeated

      if not is_nil(current_best) and current_fuel_needed > current_best do
        {:halt, :not_found}
      else
        {:cont, current_fuel_needed}
      end
    end)
    |> case do
      :not_found ->
        {current_best_point, current_best}

      new_best ->
        {point, new_best}
    end
  end

  def part1_calculator(start, destination), do: abs(start - destination)

  def part2_calculator(start, destination) do
    n = abs(start - destination)
    n * (n + 1) / 2
  end


  def read_input do
    input = File.open!("input")
    |> IO.read(:all)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    {min, max} = Enum.min_max(input)
    point_frequencies = input
      |> Enum.frequencies()
      |> Enum.sort_by(fn {_k, v} -> v end, :desc)
    {min, max, point_frequencies}
  end
end

Part1.run2()
