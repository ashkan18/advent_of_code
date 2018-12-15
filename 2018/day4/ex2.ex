defmodule Day4Ex2 do
  @shift_change ~r/\[(?<date>.+)\s(?<timestamp>.+)\] Guard #(?<id>\d+) begins shift/
  @wakes ~r/\[(?<date>.+)\s(?<timestamp>.+)\] wakes up/
  @falls ~r/\[(?<date>.+)\s(?<timestamp>.+)\] falls asleep/

  def run do
    {guard_id, {minute, total}} = read_input()
     |> Enum.sort
     |> read_log
     |> Enum.reduce(%{}, fn {guard, shifts_data}, acc ->
        Map.put(acc, guard, Enum.max_by(shifts_data, fn {_k, v} -> v end)) end
      )
     |> Enum.max_by(fn {_k, {_minute, total}} -> total end)
    guard_id * minute
  end

  def read_input, do: File.open!("input") |> IO.stream(:line)

  def read_log(data), do: read_log(data, %{})
  def read_log(data, map), do: read_log(data, map, nil, nil)
  def read_log(data, guards_data, current_gaurd), do: read_log(data, guards_data, current_gaurd, nil)
  def read_log([], map, _, _ ), do: map
  def read_log([current_record|rest], map, current_gaurd, last_sleep) do
    cond do
      String.contains?(current_record, "shift") ->
        data = parse(current_record, @shift_change)
        read_log(rest, map, String.to_integer(data["id"]))
      String.contains?(current_record, "falls") ->
        data = parse(current_record, @falls)
        read_log(rest, map, current_gaurd, data["timestamp"])
      String.contains?(current_record, "wakes") ->
        data = parse(current_record, @wakes)
        shift_data_map = shift_data(last_sleep, data["timestamp"])
        map =
            Map.update(map,
              current_gaurd,
              shift_data_map,
              fn current_shift_data ->
                shift_data_map
                  |> Enum.reduce(
                    current_shift_data,
                    fn {minute, count}, acc ->
                      Map.update(acc, minute, 1, fn current_count -> current_count + count end)
                    end)
        end)
        read_log(rest, map, current_gaurd)
    end
  end

  def parse(record, regex_type), do: Regex.named_captures(regex_type, record)
  def shift_data(fall, wake), do: Range.new(parse_timestamp(fall), parse_timestamp(wake) - 1) |> Enum.into(%{}, fn x -> {x, 1} end)
  def parse_timestamp(timestamp), do: timestamp |> String.split(":") |> Enum.map(&String.to_integer/1) |> List.last
end
