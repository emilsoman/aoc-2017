defmodule Captha do
  def sum do
    input = File.read!("1.input") |> String.trim()
    num_list = String.graphemes(input) |> Enum.map(&String.to_integer/1)
    [first | _] = num_list
    do_sum(num_list, 0, first)
  end

  def do_sum([x], sum, x) do
    sum + x
  end

  def do_sum([_], sum, _) do
    sum
  end

  def do_sum([x | [x | _] = rest], sum, first) do
    do_sum(rest, sum + x, first)
  end

  def do_sum([_ | rest], sum, first) do
    do_sum(rest, sum, first)
  end
end

defmodule Captha2 do
  def sum do
    input = File.read!("1.input") |> String.trim()
    num_list = String.graphemes(input) |> Enum.map(&String.to_integer/1)
    half_len = div(length(num_list), 2) + 1
    do_sum(num_list, 0, num_list, half_len)
  end

  def do_sum([], sum, _, _) do
    sum
  end

  def do_sum([first | rest] = next_list, sum, list, half_len) when length(next_list) < half_len do
    sub_list = next_list ++ Enum.take(list, half_len - length(next_list))
    calc_sum(sub_list, first, rest, sum, list, half_len)
  end

  def do_sum([first | rest] = next_list, sum, list, half_len) do
    sub_list = Enum.take(next_list, half_len)
    calc_sum(sub_list, first, rest, sum, list, half_len)
  end

  def calc_sum(sub_list, first, rest, sum, list, half_len) do
    sum =
      if first == Enum.at(sub_list, -1) do
        sum + first
      else
        sum
      end
    do_sum(rest, sum, list, half_len)
  end
end

IO.inspect Captha2.sum()
