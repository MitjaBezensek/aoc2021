defmodule Advent4 do
  def gen_element(curr, {row, 4, board}), do: {row + 1, 0, Map.put(board, Integer.parse(curr) |> elem(0), [row, 4])}
  def gen_element(curr, {row, col, board}), do: {row, col + 1, Map.put(board, Integer.parse(curr) |> elem(0), [row, col])}

  def generate_board(board) do
    %{cols: [5, 5, 5, 5, 5], 
      rows: [5, 5, 5, 5, 5], 
      mapping: board |> Enum.reduce({0, 0, %{}}, &gen_element/2) |> elem(2)}
  end

  def mark_number(%{cols: cols, rows: rows, mapping: mapping} = board, number) do
    if Map.has_key?(mapping, number) do
      [row, col] = Map.get(mapping, number)
      board = Map.put(board, :cols, List.update_at(cols, col, &(&1 - 1)))
      board = Map.put(board, :rows, List.update_at(rows, row, &(&1 - 1)))
      Map.put(board, :mapping, Map.drop(mapping, [number]))
    else
      board
    end
  end

  def found_winner(%{cols: cols, rows: rows}), do: Enum.any?(cols, &(&1 == 0)) or Enum.any?(rows, &(&1 == 0))

  def loop(numbers, boards, part), do: loop(numbers, boards, part, nil, nil)
  def loop([head | tail], boards, part, _, nil) do
    new_boards = 
      boards
      |> Enum.map(fn b -> mark_number(b, head) end)

    winner = new_boards |> Enum.filter(&found_winner/1)

    if part == :part1 do
      loop(tail, new_boards, part, head, List.first(winner))
    else
      if Enum.count(boards) == 1 and Enum.count(winner) == 1 do
        loop(tail, new_boards, part, head, List.first(winner))
      else
        loop(tail, Enum.reject(new_boards, &found_winner/1), part, head, nil)
      end
    end
  end
  def loop(_, _, _, number, winner), do: number * (winner |> Map.get(:mapping) |> Map.keys |> Enum.sum)

  def get_input_ready(numbers, boards) do
    numbers = String.split(numbers, ",", trim: true) |> Enum.map(fn x -> x |> Integer.parse |> elem(0) end)
    boards =
      boards
      |> Enum.map(&String.split/1)
      |> List.flatten
      |> Enum.chunk_every(25)
      |> Enum.map(&generate_board/1)
    {numbers, boards}
  end

  def play_bingo(numbers, boards) do
    {numbers, boards} = get_input_ready(numbers, boards)
    loop(numbers, boards, :part1) |> IO.inspect
    loop(numbers, boards, :part2) |> IO.inspect
  end
end

[numbers | boards] = File.read("aoc04") |> elem(1) |> String.split(~r{(\r\n|\r|\n)}, trim: true)
Advent4.play_bingo(numbers , boards)