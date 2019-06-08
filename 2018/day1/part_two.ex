defmodule PartTwo do
  def run(file_path) do
    file_path
    |> File.read!()
    |> process_input()
    |> find([0])
  end

  defp process_input(file_data) do
    file_data
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end

  defp find(original_input, seen_frequencies) do
    case find_duplicate(original_input, seen_frequencies) do
      {:found, duplicate_freq} -> duplicate_freq
      updated_seen_list -> find(original_input, updated_seen_list)
    end
  end

  def find_duplicate(original_input, seen_frequencies) do
    Enum.reduce_while(original_input, seen_frequencies,
      fn new_diff, already_seen_frequencies ->
        new_frequency = List.last(already_seen_frequencies) + new_diff
        if Enum.member?(already_seen_frequencies, new_frequency) do
          {:halt, {:found, new_frequency}}
        else
          {:cont, already_seen_frequencies ++ [new_frequency]}
        end
      end)
  end
end
