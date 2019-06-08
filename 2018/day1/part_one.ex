defmodule PartOne do
  def run(file_path) do
    file_path
      |> File.read!()
      |> process_input
      |> Enum.reduce(0, &(&1 + &2))
  end

  defp process_input(file_data) do
    file_data
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end
end
