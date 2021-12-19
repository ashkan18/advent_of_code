defmodule Board do
  @enforce_keys [:data]
  defstruct data: %{}, grid: for i <- 1..5, j <- 1..5, into: %{}, do: {"#{i}#{j}",  false }

  def new(card_rows) do
    data = for {line, row} <- Enum.with_index(card_rows, 1),
               {number, col} <- Enum.with_index(String.split(line), 1),
               into: %{} do
        {String.to_integer(number), {row, col}}
      end
    %Board{data: data}
  end

  def mark(board = %Board{data: data, grid: grid}, number) do
    case Map.fetch(data, number) do
      {:ok, {row, col} } ->
        %Board{ data: data, grid: Map.put(grid, "#{row}#{col}", true) }
      :error ->
        board
    end
  end

  def won?(%Board{grid: grid}) do
    won_column?(grid) or won_row?(grid)
  end

  defp won_row?(grid) do
    Enum.reduce_while(1..5, false, fn row, _state ->
      Enum.map(1..5, fn col ->
        Map.get(grid, "#{row}#{col}")
      end)
      |> Enum.all?()
      |> case do
        true -> {:halt, true}
        false -> {:cont, false}
      end
    end)
  end

  defp won_column?(grid) do
    Enum.reduce_while(1..5, false, fn col, _state ->
      Enum.map(1..5, fn row ->
        Map.get(grid, "#{row}#{col}")
      end)
      |> Enum.all?()
      |> case do
        true -> {:halt, true}
        false -> {:cont, false}
      end
    end)
  end

  def winning_score(last_number, %Board{data: data, grid: grid}) do
    sum = grid
      |> Enum.filter(fn {_k, v} -> v == false end)
      |> Enum.map(fn {k, _v} ->
        [row, col] = k |> String.graphemes() |> Enum.map(&String.to_integer/1)
        {number, _v} = Enum.find(data, fn {_k, v} -> v == {row, col} end)
        number
      end)
      |> Enum.sum()
    sum * last_number
  end
end

defmodule Part1 do
  def run do
    [draw_str | data] = File.open!("input")
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    draw = String.split(draw_str, ",") |> Enum.map(&String.to_integer/1)

    boards = data
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.chunk_every(5)
      |> Enum.map(fn rows -> Board.new(rows) end)

    Enum.reduce_while(draw, boards, fn read, boards ->
      boards = Enum.map(boards, &Board.mark(&1, read))
      if board = Enum.find(boards, &Board.won?/1) do
        {:halt, {read, board}}
      else
        {:cont, boards}
      end
    end)
    |> case do
      {number, board} ->
        Board.winning_score(number, board) |> IO.inspect()
      {_boards} ->
        IO.puts("didn't find")
    end
  end
end

Part1.run()
