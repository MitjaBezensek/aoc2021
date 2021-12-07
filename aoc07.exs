defmodule Advent7 do
  def median(input), do: input |> Enum.sort |> Enum.at(div(Enum.count(input), 2))

  def part1(input) do
    m = median(input)
    input |> Enum.map(&(abs(&1 - m))) |> Enum.sum
  end

  def cost(n), do: div(n * (n + 1), 2)
  def calculate_cost(n, input), do: input |> Enum.map(&(cost(abs(&1 - n)))) |> Enum.sum
  def part2(input) do
    0..Enum.count(input)
      |> Enum.map(&(calculate_cost(&1, input)))
      |> Enum.min
  end
end

input = File.read("aoc07") |> elem(1) |> String.split(",", trim: true) |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)
input |> Advent7.part1 |> IO.inspect
input |> Advent7.part2 |> IO.inspect