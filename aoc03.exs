defmodule Advent3 do
  def update_value("1", {sum, idx}, :pos), do: {sum + Integer.pow(2, idx), idx + 1}
  def update_value("0", {sum, idx}, :neg), do: {sum + Integer.pow(2, idx), idx + 1}
  def update_value(_, {sum, idx}, _), do: {sum, idx + 1}

  def calculate(occurences, bit_fn), do: Enum.reduce(occurences, {0, 0}, &(update_value(&1, &2, bit_fn)))

  def count_bit({"0", idx}, acc), do: List.update_at(acc, idx, &(&1 - 1))
  def count_bit({"1", idx}, acc), do: List.update_at(acc, idx, &(&1 + 1))

  def count_bits(curr, acc) do
    curr
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.reduce(acc, &count_bit/2)
  end

  def get_common_bits(input) do 
    Enum.reduce(input, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], &count_bits/2) 
      |> Enum.map(&(if &1 >= 0, do: "1", else: "0"))
  end

  def filter_line(f, idx, line, :oxygen), do: if f == String.at(line, idx), do: true, else: false
  def filter_line(f, idx, line, :co2), do: if f == String.at(line, idx), do: false, else: true

  def loop(input, type), do: loop(input, type, get_common_bits(input), 0)
  def loop(lines, type, f, idx) do
    if Enum.count(lines) == 1 do
      List.first(lines)
    else
      filtered = Enum.filter(lines, &(filter_line(Enum.at(f, idx), idx, &1, type)))
      loop(filtered, type, get_common_bits(filtered), idx + 1)
    end
  end

  def count1(input) do
    reversed = get_common_bits(input) |> Enum.reverse
    epsilon = calculate(reversed, :pos) |> elem(0)
    gamma = calculate(reversed, :neg) |> elem(0)
    epsilon * gamma
  end


  def count2(input) do
    oxygen = loop(input, :oxygen) |> String.split("", trim: true) |> Enum.reverse |> calculate(:pos) |> elem(0) 
    co2 = loop(input, :co2) |> String.split("", trim: true) |> Enum.reverse |> calculate(:pos) |> elem(0)
    oxygen * co2
  end
end

values = File.read("aoc03") |> elem(1) |> String.split(~r{(\r\n|\r|\n)})
values |> Advent3.count1 |> IO.inspect
values |> Advent3.count2 |> IO.inspect
