defmodule Haystack do
  @doc """
  Haystack.

  ## Examples

      iex> Haystack.run("hello", "ll")
      2

  """
  def run(haystack, needle) do
    Range.new(0, String.length(haystack) - String.length(needle))
    |> Enum.reduce_while(-1, fn idx, _ -> match?(haystack, idx, needle) end)
    |> IO.inspect()
  end

  defp match?(string, idx, needle) do
    if String.slice(string, idx, String.length(needle)) == needle, do: {:halt, idx}, else: {:cont, -1}
  end
end

Haystack.run("ashkanishavingabadday", "dd")
