defmodule Day2Ex1 do
  def run do
    readInput
     |> Enum.map(&find_counts_for_code(&1))
     |> reduce_counts
     |> calculate_result
  end

  def readInput, do: File.open!("input") |> IO.stream(:line)

  def find_counts_for_code(code) do
    code
    |> String.graphemes
    |> Enum.chunk_by(fn arg -> arg end)
    |> Enum.map(fn arg -> length(arg) end)
    |> Enum.reject(fn arg -> arg < 2 end)
    |> Enum.uniq
  end

  def reduce_counts(all_decoded) do
    all_decoded
    |> List.flatten
    |> Enum.group_by(fn arg -> arg end)
    |> Map.values
    |> Enum.map(fn item -> length(item) end)
  end

  def calculate_result(all_totals) do
    all_totals
    |> Enum.reduce(&(&1 * &2))
  end
end
