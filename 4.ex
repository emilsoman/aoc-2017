defmodule Passphrase do
  def valid_passphrases do
    "4.input"
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Enum.count(&valid?/1)
  end

  defp valid?(str) do
    list = String.split(str) |> Enum.map(fn word -> String.graphemes(word) |> Enum.sort end)
    (list -- Enum.uniq(list)) == []
  end
end

Passphrase.valid_passphrases() |> IO.inspect
