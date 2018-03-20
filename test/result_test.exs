defmodule Moonsugar.ResultTest do
  use ExUnit.Case
  alias Moonsugar.Result
  alias Moonsugar.Result, as: MR
  doctest Moonsugar.Result

  test "map example" do
    result = {:ok, "world"}
    |> MR.map(&String.upcase/1)
    |> MR.map(&(String.slice(&1, 1..3)))
    |> MR.map(&(String.duplicate(&1, 2)))

    assert result == {:ok, "ORLORL"}
  end
end
