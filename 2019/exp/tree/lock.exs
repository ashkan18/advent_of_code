defmodule Lock do
  def run(deadends, target) do
    find([{'0000', []}], deadends, target, [])
    |> IO.inspect()
  end

  def find([], _deadends, _target, _visited), do: nil
  def find([{code, path} | _r], _deadends, target, _visited) when code == target, do: path
  def find([{code, path} | r], deadends, target, visited) do
    if code in visited or code in deadends do
      find(r, deadends, target, visited)
    else
      # next combos
      next = next_combos(code)
      |> Enum.reject(fn x -> x in visited or x in deadends end)
      |> Enum.map(&({&1, path ++ [&1]}))
      find(r ++ next, deadends, target, visited ++ [code])
    end
  end

  def next_combos(code) do
    0..3
    |> Enum.reduce([], fn idx, acc ->
      acc ++ [
        List.update_at(code, idx, &(inc(&1))),
        List.update_at(code, idx, &(dec(&1)))
      ]
    end)
  end

  def inc(57), do: 48
  def inc(x), do: x + 1
  def dec(48), do: 57
  def dec(x), do: x - 1
end

Lock.run(['0201','0101','0102','1212','2002'], '0202')
Lock.run(['8887','8889','8878','8898','8788','8988','7888','9888'], '8888')
Lock.run(['8888'], '0009')
