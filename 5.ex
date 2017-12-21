defmodule Jump do
  def run do
    list =
      "5.input"
      |> File.read!
      |> String.trim()
      |> String.split()
      |> Enum.map(fn str -> String.trim(str) |> String.to_integer() end)

    execute(0, list, 0, %{})
  end

  def execute(pos, list, steps, _map) when pos >= length(list) or pos < 0 do
    steps
  end

  def execute(pos, list, steps, map) do
    val = map[pos] || Enum.at(list, pos)
    incr =
      if val >= 3 do
        -1
      else
        1
      end

    map = Map.put(map, pos, val + incr)
    execute(pos + val, list, steps + 1, map)
  end
end

Jump.run() |> IO.inspect
