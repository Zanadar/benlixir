defmodule Benlixir.Decoder do
  require IEx
  def decode(input) when is_binary(input) do
    "d"<>rest = input
    [ master,_ ] = decode_map(%{}, %{}, rest)
    {:ok, master}
  end

  def decode(_) do
    {:error, "Bad input: must be a bitstring"}
  end

  defp decode_item(map, << ch::binary-size(1), rest::binary>>) when ch == "d" do
    decode_map(map, %{}, rest)
  end

  defp decode_item(map, << ch::binary-size(1), rest::binary >>) when ch == "l" do
    decode_list(map, [], rest)
  end

  defp decode_item(map, << ch::binary-size(1), rest::binary >>) when ch == "i" do
    decode_int(map, rest)
  end

  defp decode_item(map, rest), do: decode_string(map, rest)

  defp decode_int(map, rest) do
    [int, rest] = String.split(rest, "e", parts: 2)
    [map, {int, rest}]
  end
  defp decode_map(master, map, "e"<>rest) do
    master = Map.merge(master, map)
    [map, {master, rest}]
  end
  defp decode_map(master, map, rest) do
    [master, {key, rest}] = decode_item(master, rest)
    [master, {value, rest}] = decode_item(master, rest)
    key = String.to_atom(key)
    map = Map.put(map, key, value)
    decode_map(master, map, rest)
  end

  defp decode_list(map, list, "e"<>rest), do: [map, {Enum.reverse(list), rest}]
  defp decode_list(map, list, rest) do
    [map, {item, rest}] = decode_item(map, rest)
    decode_list(map, [item | list], rest)
  end

  defp decode_string(map,rest) do
    [count, rest] = String.split(rest, ":", parts: 2)
    count = String.to_integer(count)
    << word::binary-size(count), rest::binary >> = rest
    [map, {word, rest} ]
  end

end
