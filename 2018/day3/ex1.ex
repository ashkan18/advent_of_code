defmodule Day3Ex1 do
  @claim_regex ~r/#(?<claim_id>\d+) @ (?<row_offset>\d+),(?<column_offset>\d+): (?<width>\d+)x(?<height>\d+)/

  def run do
    readInput
    |> Enum.map(&parse_claim/1)
    |> Enum.map(&generate_row/1)
    |> Enum.reduce(%{}, &populate_map_with_row(&1, &2))
    |> count_overlaps
  end

  defp readInput, do: File.open!("input") |> IO.stream(:line)

  def generate_row(cl) do
    for row <- cl.row_offset..(cl.row_offset + cl.height), column <- cl.column_offset..(cl.column_offset + cl.width), into: [] do
      [row, column]
    end
  end

  def populate_map_with_row(row_columns, map) do
    row_columns
    |> Enum.map(fn [row, column] ->
      {_, updated_map} = Map.get_and_update(map, row, fn column_map ->
        {_, new_map} = Map.get_and_update((column_map || %{column => 0}), column, fn current_column -> (current_column || 0) + 1 end)
        new_map
      end)
      updated_map
    end)
  end

  def parse_claim(claim) do
    # #1 @ 755,138: 26x19
    parsed_claim = Regex.named_captures(@claim_regex, claim)
    %{
      claim_id: parsed_claim["claim_id"],
      column_offset: String.to_integer(parsed_claim["column_offset"]),
      row_offset: String.to_integer(parsed_claim["row_offset"]),
      width: String.to_integer(parsed_claim["width"]),
      height: String.to_integer(parsed_claim["height"])
    }
  end

  def count_overlaps(map) do
    map
    |> Enum.reduce(0, fn {_k, row_data}, current_count ->
      current_count + count_overlap_in_row(row_data)
    end)
  end

  def count_overlap_in_row(row_data) do
    row_data
    |> Enum.reduce(0, fn {_row, column_data}, count ->
      count + Enum.reduce(column_data, 0, fn column, column_count -> if column > 1, do: column_count + 1, else: column_count end)
    end)
  end
end