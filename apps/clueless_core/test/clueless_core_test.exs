defmodule CluelessCoreTest do
  use ExUnit.Case
  doctest CluelessCore

  test "greets the world" do
    assert CluelessCore.hello() == :world
  end
end
