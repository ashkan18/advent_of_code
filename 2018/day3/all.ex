defmodule Day3Ex1 do
  @claim_regex ~r/#(?<claim_id>\d+) @ (?<row_offset>\d+),(?<column_offset>\d+): (?<width>\d+)x(?<height>\d+)/

  def run1 do
    readInput()
    |> Enum.map(&parse_claim/1)
    |> Enum.reduce(%{}, &add_claim_to_map/2)
    |> Enum.count(fn {_k, {v, _}} -> v > 1 end)
  end

  def run2 do
    overlapped_claims = readInput()
      |> Enum.map(&parse_claim/1)
      |> Enum.reduce(%{}, &add_claim_to_map/2)
      |> Enum.reduce(MapSet.new(), fn {_k, {v, claim_ids}}, overlapped_claims_set ->
          if v > 1 do
            Enum.reduce(claim_ids, overlapped_claims_set, fn claim_id, acc -> MapSet.put(acc, claim_id) end)
          else
            overlapped_claims_set
          end
        end)
      readInput()
        |> Enum.map(&parse_claim/1)
        |> Enum.reduce(MapSet.new(), fn claim, acc -> MapSet.put(acc, claim.id) end)
        |> MapSet.difference(overlapped_claims)
  end

  defp readInput, do: File.open!("input") |> IO.stream(:line)

  def add_claim_to_map(claim, map) do
    claim_coords = for row <- Range.new(0, claim.width - 1), column <- Range.new(0, claim.height - 1), do: {row, column}
    Enum.reduce(claim_coords, map, fn {x, y}, acc ->
      Map.update(
        acc,
        {claim.row_offset + x, claim.column_offset + y},
        {1, [claim.id]},
        fn {count, claims} ->
          {count+1, [claim.id| claims]}
        end)
    end)
  end

  def parse_claim(claim) do
    # #1 @ 755,138: 26x19
    parsed_claim = Regex.named_captures(@claim_regex, claim)
    %{
      id: parsed_claim["claim_id"],
      row_offset: String.to_integer(parsed_claim["row_offset"]),
      column_offset: String.to_integer(parsed_claim["column_offset"]),
      width: String.to_integer(parsed_claim["width"]),
      height: String.to_integer(parsed_claim["height"])
    }
  end
end