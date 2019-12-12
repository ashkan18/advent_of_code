defmodule Part1 do
  def run1 do
    read_input()
    |> generate_map()
    |> calculate_checksum()
    |> IO.inspect()
  end

  def run2 do
    read_input()
    |> generate_map()
    |> find_shortest("YOU", "SAN")
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

  defp find_shortest(map, start, finish) do
    start_path_to_com = path(start, map, []) |> Enum.reverse() |> Enum.drop(1) |> IO.inspect()
    finish_path_to_com = path(finish, map, []) |> Enum.reverse() |> Enum.drop(1) |> IO.inspect()
    start_path_to_com
    |> Enum.reduce_while(0, &find_in_finish_path(&1, &2, finish_path_to_com))
    |> IO.inspect()
  end

  defp path(nil, _map, path), do: path
  defp path(start, map, path), do: path(Map.get(map, start), map, [start | path])

  defp find_in_finish_path(node, current_count, finish_path_to_com) do
    case Enum.find_index(finish_path_to_com, fn x -> x == node end) do
      nil -> {:cont, current_count + 1}
      index -> {:halt, current_count + index}
    end
  end
end

Part1.run2()
