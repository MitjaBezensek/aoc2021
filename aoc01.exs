defmodule Advent1 do
  def count_depth(curr, {result, prev}) when curr > prev, do: {result + 1, curr}
  def count_depth(curr, {result, _}), do: {result, curr}

  def depth([head | tail]), do: Enum.reduce(tail, {0, head}, &count_depth/2) |> elem(0)

  def window(input) do
    input
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
  end
end

{:ok, input} = File.read("aoc01") 
values = input |> String.split(~r{(\r\n|\r|\n)}) |> Enum.map(&String.to_integer/1)
values |> Advent1.depth |> IO.puts
values |> Advent1.window |> Advent1.depth |> IO.puts
