defmodule BenlixirTest do
  use ExUnit.Case
  alias Benlixir.Decoder
  ExUnit.configure exclude: :pending

  doctest Benlixir

  setup_all do
    input = "d8:announce41:http://bttracker.debian.org:6969/announce7:comment35:\"Debian CD from cdimage.debian.org\"13:creation datei1391870037e9:httpseedsl85:http://cdimage.debian.org/cdimage/release/7.4.0/iso-cd/debian-7.4.0-amd64-netinst.iso85:http://cdimage.debian.org/cdimage/archive/7.4.0/iso-cd/debian-7.4.0-amd64-netinst.isoe4:infod6:lengthi232783872e4:name30:debian-7.4.0-amd64-netinst.iso12:piece lengthi262144e6:pieces0:ee"
    {:ok, data: input}
  end

  @tag :pending
  test "Decoder always returns a map", %{data: input} do
    {:ok, message} = Decoder.decode(input)
    assert is_map(message)
  end

  @tag :pending
  test "Decoder throws when given anything other than a bitstring", %{data: input} do
    input = []
    {error, _} = Decoder.decode(input)
    assert error == :error
  end

  test "Decode 'd4:test4:teste'" do
    input = "d4:test4:teste"
    assert Decoder.decode(input) == {:ok, %{test: "test"}}
  end

  test "Decode 'd4:test4:test3:foo3:bare'" do
    input = "d4:test4:test3:foo3:bare"
    assert Decoder.decode(input) == {:ok, %{foo: "bar", test: "test"}}
  end

  test "Decode with list as value" do
    input = "d4:listl3:one3:two5:threeee"
    assert Decoder.decode(input) == {:ok, %{list: ["one", "two", "three"]}}
  end

  test "Decode with list and string as value" do
    input = "d4:listl3:one3:two5:threee3:foo3:bare"
    assert Decoder.decode(input) == {:ok, %{list: ["one", "two", "three"], foo: "bar"}}
  end
end
