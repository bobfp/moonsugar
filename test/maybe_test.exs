defmodule Moonsugar.MaybeTest do
  use ExUnit.Case
  alias Moonsugar.Maybe
  doctest Moonsugar.Maybe

  test "just" do
    assert Maybe.just(3) == {:just, 3}
  end
end
