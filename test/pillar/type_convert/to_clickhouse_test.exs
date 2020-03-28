defmodule Pillar.TypeConvert.ToClickhouseTest do
  alias Pillar.TypeConvert.ToClickhouse
  use ExUnit.Case

  describe "#convert/1" do
    test "nil" do
      assert ToClickhouse.convert(nil) == "NULL"
    end

    test "Date" do
      assert ToClickhouse.convert(~D[1970-01-01]) == "'1970-01-01'"
    end

    test "String" do
      assert ToClickhouse.convert("Hello") == "'Hello'"

      assert ToClickhouse.convert("Hello, here is single qoute '") ==
               "'Hello, here is single qoute '''"

      assert ToClickhouse.convert("Hello, here are two single qoutes '' ") ==
               "'Hello, here are two single qoutes '''' '"

      assert ToClickhouse.convert("Hello, here are two double qoutes \"\" ") ==
               "'Hello, here are two double qoutes \"\" '"
    end

    test "Map" do
      assert ToClickhouse.convert(%{key: "value"}) == ~S('{"key":"value"}')
    end

    test "Bool" do
      assert ToClickhouse.convert(true) == "1"
      assert ToClickhouse.convert(false) == "0"
    end

    test "DateTime" do
      assert ToClickhouse.convert(~U[2020-03-26 22:26:14.286832Z]) == "'2020-03-26T22:26:14'"
    end

    test "List" do
      assert ToClickhouse.convert([
               1,
               2,
               true,
               false,
               ~D[1970-01-01],
               %{"key" => "value"},
               ~U[2020-03-26 22:26:14.286832Z],
               "Le'Blank"
             ]) == ~S([1,2,1,0,'1970-01-01','{"key":"value"}','2020-03-26T22:26:14','Le''Blank'])

      # array with array
      assert ToClickhouse.convert([
               []
             ]) == "[[]]"
    end
  end
end
