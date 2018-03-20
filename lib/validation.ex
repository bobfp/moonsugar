defmodule Moonsugar.Validation do
  @moduledoc """
  The Validation module contains functions that help create and interact with the validation type.
  The Validation type is represented as either `{:success, value}` or `{:failure, reasons}`
  """

  @doc """
  Helper function to create a success tuple.

  ## Examples

      iex> Validation.success(3)
      {:success, 3}

  """
  def success(val) do
    {:success, val}
  end

  @doc """
  Helper function to create a failure tuple.

  ## Examples

      iex> Validation.failure(["Goat is floating"])
      {:failure, ["Goat is floating"]}

  """
  def failure(reasons) do
    {:failure, reasons}
  end

  @doc """
  Combines validation types. Failures are concatenated. Concatenating two success types returns the last one.

  ## Examples

      iex> Validation.concat({:failure, ["not enough chars"]}, {:failure, ["not long enough"]})
      {:failure, ["not enough chars", "not long enough"]}

      iex> Validation.concat({:failure, ["Game Crashed"]}, {:success, 3})
      {:failure, ["Game Crashed"]}

      iex> Validation.concat({:success, 2}, {:success, 3})
      {:success, 3}

  """
  def concat({:success, _}, {:failure, reasonsB}), do: {:failure, reasonsB}
  def concat({:failure, reasonsA}, {:success, _}), do: {:failure, reasonsA}
  def concat({:success, _}, {:success, valB}), do: {:success, valB}

  def concat({:failure, reasonsA}, {:failure, reasonsB}) do
    {:failure, Enum.concat(reasonsA, reasonsB)}
  end

  @doc """
  Combines an array of validation types.

  ## Examples

      iex> Validation.collect([{:failure, ["not long enough"]}, {:failure, ["not enough special chars"]}, {:failure, ["not enough capital letters"]}])
      {:failure, ["not long enough", "not enough special chars", "not enough capital letters"]}

  """
  def collect(validators) do
    Enum.reduce(Enum.reverse(validators), &concat/2)
  end

  @doc """
  Maps over a validation type, only applies the function to success tuples.

  ## Examples

      iex> Validation.map({:success, 3}, fn(x) -> x * 2 end)
      {:success, 6}

      iex> Validation.map({:failure, ["Dwarves"]}, fn(x) -> x * 2 end)
      {:failure, ["Dwarves"]}
  """
  def map(result, fun) do
    case result do
      {:success, val} -> success(fun.(val))
      error -> error
    end
  end

  @doc """
  Maps over a validation type, only applies the function to failure tuples.

  ## Examples

      iex> Validation.mapFailure({:success, 3}, fn(x) -> x * 2 end)
      {:success, 3}

      iex> Validation.mapFailure({:failure, ["Dwarves"]}, &String.upcase/1)
      {:failure, ["DWARVES"]}
  """
  def mapFailure(validation, fun) do
    case validation do
      {:failure, reasonss} -> failure(Enum.map(reasonss, &fun.(&1)))
      success -> success
    end
  end

  @doc """
  Converts a variable that might be nil to a validation type.

  ## Examples

      iex> Validation.from_nilable("khajiit has wares", ["khajiit does not have wares"])
      {:success, "khajiit has wares"}

      iex> Validation.from_nilable(nil, ["khajiit does not have wares"])
      {:failure, ["khajiit does not have wares"]}
  """
  def from_nilable(val, failure) do
    cond do
      is_nil(val) -> {:failure, failure}
      true -> success(val)
    end
  end

  @doc """
  Converts a variable from a maybe type to a validation type.

  ## Examples

      iex> Validation.from_maybe({:just, 3}, ["Not a number"])
      {:success, 3}

      iex> Validation.from_maybe(:nothing, ["Not a number"])
      {:failure, ["Not a number"]}
  """
  def from_maybe(result, failure) do
    case result do
      {:just, val} -> {:success, val}
      _ -> {:failure, failure}
    end
  end

  @doc """
  Converts a variable from a result type to a validation type.

  ## Examples

      iex> Validation.from_result({:ok, "Dragon Slayed"})
      {:success, "Dragon Slayed"}

      iex> Validation.from_result({:error, "You Died"})
      {:failure, ["You Died"]}
  """
  def from_result(result) do
    case result do
      {:ok, val} -> {:success, val}
      {:error, error} -> {:failure, [error]}
    end
  end
end
