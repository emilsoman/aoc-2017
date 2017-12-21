defmodule Spiral do
  def distance(1), do: 0

  def distance(val) do
    n = :math.sqrt(val) |> trunc()
    layer = div((n + 1), 2)
    layer + layer_distance(val, layer)
  end

  def layer_distance(val, layer) do
    layer_len = 8 * layer
    side_len = div(layer_len, 4)
    prev_square = (2 * layer - 1) |> :math.pow(2) |> trunc()
    side_index = div((4 * (val - prev_square)), layer_len)
    ref = (side_len * side_index) + prev_square + div(side_len, 2)
    abs(val - ref)
  end
end

#IO.inspect Spiral.distance(347991)

defmodule Spiral2 do
  def generate do
    start = {0, 0}
    Spiral2.Square.set(start)
    spawn_next(start)
  end

  def spawn_next(prev_coordinates) do
    coordinates = next_coordinates(prev_coordinates)
    val = Spiral2.Square.set(coordinates)
    if val > 347991 do
      IO.inspect val
    else
      spawn_next(coordinates)
    end
  end

  defp next_coordinates({0, 0}) do
    {1, 0}
  end
  defp next_coordinates({x, y}) when x > 0 and x == y do
    {x - 1, y}
  end
  defp next_coordinates({x, y}) when x > 0 and x == (-y) do
    {x + 1, y}
  end
  defp next_coordinates({x, y}) when x < 0 and x == (-y) do
    {x, y - 1}
  end
  defp next_coordinates({x, y}) when x < 0 and x == y do
    {x + 1, y}
  end
  defp next_coordinates({x, y}) do
    layer = max(abs(x), abs(y))
    get_next_in_layer(x, y, layer)
  end

  defp get_next_in_layer(x, y, layer) when x == layer do
    {x, y + 1}
  end

  defp get_next_in_layer(x, y, layer) when y == layer do
    {x - 1, y}
  end

  defp get_next_in_layer(x, y, layer) when x == -(layer) do
    {x, y - 1}
  end

  defp get_next_in_layer(x, y, layer) when y == -(layer) do
    {x + 1, y}
  end
end

defmodule Spiral2.Square do
  use Agent

  def set({0, 0}) do
    init(1, {0, 0})
  end

  def set({x, y} = coordinates) do
    vals = for x <- [x - 1, x, x + 1], y <- [y - 1, y, y + 1], do: get({x, y})
    Enum.sum(vals) |> init(coordinates)
  end

  def init(val, coordinates) do
    Agent.start_link(fn -> val end, name: name(coordinates))
    IO.inspect "#{val} in #{inspect coordinates}"
    val
  end

  def get(coordinates) do
    if Process.whereis(name(coordinates)) do
      Agent.get(name(coordinates), fn val -> val end)
    else
      0
    end
  end

  defp name({x, y}) do
    String.to_atom("#{x}_#{y}")
  end
end

Spiral2.generate()

#Process.sleep(5000)
