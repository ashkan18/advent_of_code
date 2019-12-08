defmodule Part1 do
  def run do
    read_input()
    |> generate_map()
    |> calculate_checksum()
    |> IO.inspect()
  end

  defp read_input, do: File.open!("data") |> IO.stream(:line) |> Stream.map(&String.trim/1) |> Stream.map(&(String.split(&1, ")")))

  defp generate_map(data) do
    data
    |> Enum.reduce(%{}, &add_data/2)
  end

  defp calculate_checksum(map) do
    map
    |> Map.keys()
    |> Enum.map(&find_orbits(&1, map))
    |> Enum.sum()
  end

  defp add_data([a, b], map), do: Map.put_new(map, b, a)

  defp find_orbits(key, map), do: find_orbits(key, map, 0)
  defp find_orbits(nil, _map, count), do: count
  defp find_orbits(key, map, count) do
    map
    |> Map.get(key)
    |> find_orbits(map, count + 1)
  end
end

Part1.run()