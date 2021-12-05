defmodule Advent2 do
  def move([dim, v], acc), do: step(dim, (String.to_integer v), acc)
  
  def step("forward", v, {h, d}), do: {h + v, d}
  def step("up", v, {h, d}), do: {h, d - v}
  def step("down", v, {h, d}), do: {h, d + v}
  def step("forward", v, {h, d, a}), do: {h + v, d + v * a, a}
  def step("up", v, {h, d, a}), do: {h, d, a - v}
  def step("down", v, {h, d, a}), do: {h, d, a + v}

  def travel(input, start) do
    result = Enum.reduce(input, start, &move/2)
    elem(result, 0) * elem(result, 1) 
  end 
end

values = File.read("aoc02") |> elem(1) |> String.split(~r{(\r\n|\r|\n)}) |> Enum.map(&String.split/1)
values |> Advent2.travel({0, 0}) |> IO.inspect
values |> Advent2.travel({0, 0, 0}) |> IO.inspect