defmodule Advent5 do
  def gen1(x1, y1, x2, y2) do
     if x1 != x2 and y1 != y2  do
      []
    else
      for x <- x1..x2,  y <- y1..y2 do
        [x, y]
      end
    end
  end

  def get_step(v1, v2) do
    cond do
      v1 == v2 -> 0
      (v2 - v1) < 0 -> -1
      true -> 1
    end
  end

  def gen2(x, y, x, y, _, _, result), do: [[x, y] | result]
  def gen2(x1, y1, x2, y2, x_step, y_step, result) do
    gen2(x1 + x_step, y1 + y_step, x2, y2, x_step, y_step, [[x1, y1] | result])
  end

  def gen2(x1, y1, x2, y2), do: gen2(x1, y1, x2, y2, get_step(x1, x2), get_step(y1, y2), [])

  def add_lines(curr, lines, gen_fn) do
    [x1, y1] = curr |> Enum.at(0) |> String.split(",", trim: true) |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)
    [x2, y2] = curr |> Enum.at(1) |> String.split(",", trim: true) |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)
    gen_fn.(x1, y1, x2, y2)
      |> Enum.reduce(lines, fn x, l -> Map.update(l, x, 1, fn x -> x + 1 end) end)
  end

  def count(input, gen_fn) do
    input
      |> Enum.map(fn x -> String.split(x, " -> ", trim: true) end)
      |> Enum.reduce(%{}, fn curr, acc -> add_lines(curr, acc, gen_fn) end)
      |> Map.values
      |> Enum.filter(&(&1 > 1))
      |> Enum.count
  end
end

input = File.read("aoc05") |> elem(1) |> String.split(~r{(\r\n|\r|\n)}, trim: true) 
Advent5.count(input, &Advent5.gen1/4) |> IO.inspect
Advent5.count(input, &Advent5.gen2/4) |> IO.inspect