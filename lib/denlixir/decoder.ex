defmodule Benlixir.Decoder do
  def decode(input) when is_binary(input) do
    "d"<>rest = input
    {:ok, decode_map(%{}, rest)}
  end

  def decode(_) do
    {:error, "Bad input: must be a bitstring"}
  end

  defp decode(map, "e"), do: map
  defp decode(map, rest) do
    decode_map(map, rest)
  end

  defp decode_item(map, << ch::binary-size(1), rest::binary>>) when ch == "d" do
    decode_map(map, rest)
  end

  defp decode_item(map, << ch::binary-size(1), rest::binary >>) when ch == "l" do
    decode_list(map, [], rest)
  end

  defp decode_item(map, << ch::binary-size(1), rest::binary >>) when ch == "i" do
    rest |> IO.puts
  end

  defp decode_item(map, rest), do: decode_string(map, rest)

  defp decode_map(map, "e"<>_), do: map
  defp decode_map(map, rest) do
    [map, {key, rest}] = decode_item(map, rest)
    [map, {value, rest}] = decode_item(map, rest)
    key = String.to_atom(key)
    map = Map.put(map, key, value)
    decode(map, rest)

  end

  defp decode_list(map, list, "e"<>rest), do: [map, {Enum.reverse(list), rest}]
  defp decode_list(map, list, rest) do
    [map, {item, rest}] = decode_item(map, rest)
    decode_list(map, [item | list], rest)
  end

  defp decode_string(map, << ch::binary-size(2), rest::binary >> ) do
    count = ch |> String.first |> String.to_integer
    << word::binary-size(count), rest::binary >> = rest
    [map, {word, rest} ]
  end

end
