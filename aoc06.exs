defmodule Advent6 do
  def gen_map(input), do: Enum.reduce(input, %{}, &(Map.update(&2, &1, 1, fn x -> x + 1 end)))

  def update(day, map) do
    if Map.has_key?(map, day) do
      value = Map.get(map, day)
      if day == 0 do
        Map.drop(map, [0]) |> Map.put(9, value) |> Map.update(7, value, fn x -> x + value end)
      else
        Map.drop(map, [day]) |> Map.put(day - 1, value)
      end
    else 
      map
    end
  end

  def simulate_day(result, 0), do: result |> Map.values() |> Enum.sum
  def simulate_day(sf_map, days) do
    map = 0..9 |> Enum.reduce(sf_map, &update/2)
    simulate_day(map, days - 1)
  end

  def evolve(input, days), do: input |> gen_map |> simulate_day(days)
end

input = File.read("aoc06") |> elem(1) |> String.split(",", trim: true) |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)
input |> Advent6.evolve(80) |> IO.inspect
input |> Advent6.evolve(256) |> IO.inspect