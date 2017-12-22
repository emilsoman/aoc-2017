defmodule BlockDistribution do
  def run do
    banks =
      File.read!("6.input")
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    seen = []
    cycles = 0
    tick(banks, cycles, seen)
  end

  defp tick(banks, cycles, seen) do
    banks_string = Enum.join(banks)
    if banks_string in seen do
      cycles
    else
      seen = [banks_string | seen]
      banks = redistribute(banks)
      tick(banks, cycles + 1, seen)
    end
  end

  defp redistribute(banks) do
    blocks_with_index = Enum.with_index(banks)
    {blocks, index} = Enum.max_by(blocks_with_index, fn {blocks, _i} -> blocks end)
    do_fill(banks, blocks, index, 0, false, [])
  end

  defp do_fill(rest, 0, _index, _i, true, acc) do
    Enum.reverse(acc) ++ rest
  end
  defp do_fill([head | rest], blocks, index, i, false, acc) do
    head =
      if i == index do
        0
      else
        head
      end

    acc = [head | acc]

    {acc, rest} =
      if rest == [] do
        {[], Enum.reverse acc}
      else
        {acc, rest}
      end
    do_fill(rest, blocks, index, i + 1, i >= index, acc)
  end
  defp do_fill([head | []], blocks, index, _i, true, acc) do
    acc = [head + 1 | acc]
    do_fill(Enum.reverse(acc), blocks - 1, index, 0, true, [])
  end
  defp do_fill([head | rest], blocks, index, i, true, acc) do
    acc = [head + 1 | acc]
    acc =
      if rest == [] do
        Enum.reverse(acc)
      else
        acc
      end
    do_fill(rest, blocks - 1, index, i + 1, true, acc)
  end
end

BlockDistribution.run() |> IO.inspect
