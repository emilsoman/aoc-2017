defmodule Checksum do
  def calculate do
    input =
      "2.input"
      |> File.read!()
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn row -> String.split(row, "\t") |> Enum.map(&String.to_integer/1) end)

    Enum.reduce(input, 0, fn row, sum ->
      {min, max} = Enum.min_max(row)
      sum + (max - min)
    end)
  end
end

defmodule Checksum2 do
  def calculate do
    input =
      "2.input"
      |> File.read!()
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn row -> String.split(row, "\t") |> Enum.map(&String.to_integer/1) end)

    Enum.reduce(input, 0, fn row, sum ->
      sum + get_result(Enum.sort(row))
    end)
  end

  defp get_result([x, y]) do
    div(y, x)
  end

  defp get_result([min | rest]) do
    case get_result(min, rest) do
      {:ok, result} -> result
      _ -> get_result(rest)
    end
  end

  defp get_result(_, []) do
    :error
  end

  defp get_result(min, [next | rest]) do
    if is_integer?(next / min) do
      {:ok, div(next, min)}
    else
      get_result(min, rest)
    end
  end

  defp is_integer?(num) do
    trunc(num) == num
  end
end

IO.inspect Checksum2.calculate()
