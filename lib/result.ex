defmodule Moonsugar.Result do
  @moduledoc """
  The Result module contains functions that help create and interact with the result type.
  """

  @doc """
  Helper function to create an ok type

  ## Examples

  iex> Result.ok(3)
  {:ok, 3}

  """
  def ok(val) do
    {:ok, val}
  end

  @doc """
  Helper function to create a error type

  ## Examples

  iex> Result.error("Goat is floating")
  {:error, "Goat is floating"}

  """
  def error(reason) do
    {:error, reason}
  end

  @doc """
  Extracts a value from a result type
  If the provided argument doesn't have a value, the default is returned

  ## Examples

  iex> Result.getWithDefault({:ok, 3}, 0)
  3

  iex> Result.getWithDefault({:error, "Game Crashed"}, 0)
  0

  """
  def getWithDefault(result, default) do
    case result do
      {:ok, val} -> val
      _ -> default
    end
  end

  @doc """
  maps over a result type

  ## Examples

  iex> Result.map({:ok, 3}, fn(x) -> x * 2 end)
  {:ok, 6}

  iex> Result.map({:error, "Dwarves"}, fn(x) -> x * 2 end)
  {:error, "Dwarves"}
  """
  def map(result, fun) do
    case result do
      {:ok, val} -> ok(fun.(val))
      error -> error
    end
  end

  @doc """
  Like map, but chain takes a function that returns a result type
  This prevents nested results

  ## Examples

  iex> Result.map({:ok, 3}, fn(x) ->
  ...>   cond do
  ...>     x > 0 -> {:ok, x * 3}
  ...>     x <= 0 -> {:error, "number less than 1"}
  ...>   end
  ...> end)
  {:ok, {:ok, 9}}

  iex> Result.chain({:ok, 3}, fn(x) ->
  ...>   cond do
  ...>     x > 0 -> {:ok, x * 3}
  ...>     x <= 0 -> {:error, "number less than 1"}
  ...>   end
  ...> end)
  {:ok, 9}

  iex> Result.chain({:ok, 0}, fn(x) ->
  ...>   cond do
  ...>     x > 0 -> {:ok, x * 3}
  ...>     x <= 0 -> {:error, "number less than 1"}
  ...>   end
  ...> end)
  {:error, "number less than 1"}

  iex> Result.chain({:error, "no number found"}, fn(x) ->
  ...>   cond do
  ...>     x > 0 -> {:ok, x * 3}
  ...>     x <= 0 -> {:error, "number less than 1"}
  ...>   end
  ...> end)
  {:error, "no number found"}
  """
  def chain(result, fun) do
    with {:ok, val} <- result,
         {:ok, innerVal} <- fun.(val) do
      {:ok, innerVal}
    else
      error -> error
    end
  end

  # TODO implement this probably
  # def or_else(result, fun) do
  #   case result do
  #     {:just, _} -> true
  #     :nothing -> true
  #     _ -> false
  #   end
  # end

  @doc """
  determines if a value is a result type

  ## Examples
  iex> Result.is_result({:ok, 0})
  true

  iex> Result.is_result({:error, "Not enough ore"})
  true

  iex> Result.is_result({:just, 3})
  false
  """
  def is_result(result) do
    case result do
      {:ok, _} -> true
      {:error, _} -> true
      _ -> false
    end
  end

  @doc """
  converts a variable that might be nil to a result type

  ## Examples
  iex> Result.from_nilable("khajiit has wares", "khajiit does not have wares")
  {:ok, "khajiit has wares"}

  iex> Result.from_nilable(nil, "khajiit does not have wares")
  {:error, "khajiit does not have wares"}
  """
  def from_nilable(val, error) do
    cond do
      is_nil(val) -> {:error, error}
      true -> ok(val)
    end
  end

  @doc """
  converts a variable from a maybe type to a result type

  ## Examples
  iex> Result.from_maybe({:just, 3}, "Not a number")
  {:ok, 3}

  iex> Result.from_maybe(:nothing, "Not a number")
  {:error, "Not a number"}
  """
  def from_maybe(result, error) do
    case result do
      {:just, val} -> {:ok, val}
      _ -> {:error, error}
    end
  end

  @doc """
  converts a variable from a validation type to a result type

  ## Examples
  iex> Result.from_validation({:success, "Dragon Slayed"})
  {:ok, "Dragon Slayed"}

  iex> Result.from_validation({:fail, ["You Died", "You ran out of mana"]})
  {:error, ["You Died", "You ran out of mana"]}
  """
  def from_validation(result) do
    case result do
      {:success, val} -> {:ok, val}
      {:fail, error} -> {:error, error}
    end
  end

  @doc """
  Attempts to do something that might throw an error, and converts the out put to a result type

  ## Examples
  iex> Result.attempt("Shoot Elf")
  {:ok, "Shoot Elf"}

  iex> Result.attempt(raise("You Died"))
  {:error, "You Died"}
  """
  defmacro attempt(thing) do
    quote do
      try do
        {:ok, unquote(thing)}
      rescue
        e in _ -> {:error, e.message}
      end
    end
  end
end
