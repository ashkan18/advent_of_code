defmodule Day4Gaurds do
  @shift_change ~r/\[(?<date>.+)\s(?<timestamp>.+)\] Guard #(?<id>\d+) begins shift/
  @wakes ~r/\[(?<date>.+)\s(?<timestamp>.+)\] wakes up/
  @falls ~r/\[(?<date>.+)\s(?<timestamp>.+)\] falls asleep/

  def st1 do
    {guard_id, shift_data} = readInput()
     |> Enum.sort
     |> read_log
     |> Enum.max_by(
       fn {_k, shift_data} ->
        Map.values(shift_data) |> Enum.sum() end
     )
     {best_minute, _count} = Enum.max_by(shift_data, fn {_k, v} -> v end)
     guard_id * best_minute
  end

  def st2 do
    {guard_id, {minute, _total}} = read_input()
     |> Enum.sort
     |> read_log
     |> Enum.reduce(%{}, fn {guard, shifts_data}, acc ->
        Map.put(acc, guard, Enum.max_by(shifts_data, fn {_k, v} -> v end)) end
      )
     |> Enum.max_by(fn {_k, {_minute, total}} -> total end)
    guard_id * minute
  end

  defp readInput, do: File.open!("input") |> IO.stream(:line)

  defp read_log(data), do: read_log(data, %{})
  defp read_log(data, map), do: read_log(data, map, nil, nil)
  defp read_log(data, guards_data, current_gaurd), do: read_log(data, guards_data, current_gaurd, nil)
  defp read_log([], map, _, _ ), do: map
  defp read_log([current_record|rest], map, current_gaurd, last_sleep) do
    cond do
      String.contains?(current_record, "shift") ->
        data = parse_record(current_record, @shift_change)
        read_log(rest, map, String.to_integer(data["id"]))
      String.contains?(current_record, "falls") ->
        data = parse_record(current_record, @falls)
        read_log(rest, map, current_gaurd, data["timestamp"])
      String.contains?(current_record, "wakes") ->
        data = parse_record(current_record, @wakes)
        updated_map = update_sleep_map(map, current_gaurd, last_sleep, data)
        read_log(rest, updated_map, current_gaurd)
    end
  end

  defp parse_record(record, regex_type), do: Regex.named_captures(regex_type, record)
  defp shift_data(fall, wake), do: Range.new(parse_timestamp(fall), parse_timestamp(wake) - 1) |> Enum.into(%{}, fn x -> {x, 1} end)
  defp parse_timestamp(timestamp), do: timestamp |> String.split(":") |> Enum.map(&String.to_integer/1) |> List.last
  defp update_sleep_map(map, current_gaurd, last_sleep, wake_data) do
    new_sleep_data = shift_data(last_sleep, wake_data["timestamp"])
    Map.update(map, current_gaurd, new_sleep_data, &update_current_guard_data(&1, new_sleep_data))
  end

  defp update_current_guard_data(current_gaurd_data, new_data) do
    new_data
      |> Enum.reduce(
        current_gaurd_data,
        fn {minute, count}, acc -> Map.update(acc, minute, 1, fn current_count -> current_count + count end) end)
  end
end
