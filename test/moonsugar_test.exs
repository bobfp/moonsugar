defmodule MoonsugarTest do
  use ExUnit.Case
  doctest Moonsugar

  test "greets the world" do
    assert Moonsugar.hello() == :world
  end
end
