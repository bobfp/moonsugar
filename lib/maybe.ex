defmodule Moonsugar.Maybe do
  @moduledoc """
  The Maybe module contains functions that help create and interact with the maybe type.
  The Maybe type used in this library is represented as either a Just type or a Nothing type.
  """

  @doc """
  Helper function to create a just type

  ## Examples

  iex> Maybe.just(3)
  {:just, 3}

  """
  def just(val) do
    {:just, val}
  end

  @doc """
  Helper function to create a nothing type

  ## Examples

  iex> Maybe.nothing()
  :nothing

  """
  def nothing() do
    :nothing
  end

  @doc """
  Extracts a value from a maybe type
  If the provided argument doesn't have a value, the default is returned

  ## Examples

  iex> Maybe.getWithDefault({:just, 3}, 0)
  3

  iex> Maybe.getWithDefault(:nothing, 0)
  0

  """
  def getWithDefault(maybe, default) do
    case maybe do
      {:just, val} -> val
      _ -> default
    end
  end

  @doc """
  maps over a maybe type

  ## Examples

  iex> Maybe.map({:just, 3}, fn(x) -> x * 2 end)
  {:just, 6}

  iex> Maybe.map(:nothing, fn(x) -> x * 2 end)
  :nothing
  """
  def map(maybe, fun) do
    case maybe do
      {:just, val} -> just(fun.(val))
      _ -> :nothing
    end
  end

  @doc """
  Like map, but chain takes a function that returns a maybe type
  This prevents nested maybes

  ## Examples

  iex> Maybe.map({:just, 3}, fn(x) ->
  ...>   cond do
  ...>     x > 0 -> {:just, x * 3}
  ...>     x <= 0 -> :nothing
  ...>   end
  ...> end)
  {:just, {:just, 9}}

  iex> Maybe.chain({:just, 3}, fn(x) ->
  ...>   cond do
  ...>     x > 0 -> {:just, x * 3}
  ...>     x <= 0 -> :nothing
  ...>   end
  ...> end)
  {:just, 9}

  iex> Maybe.chain({:just, 0}, fn(x) ->
  ...>   cond do
  ...>     x > 0 -> {:just, x * 3}
  ...>     x <= 0 -> :nothing
  ...>   end
  ...> end)
  :nothing
  """
  def chain(maybe, fun) do
    with {:just, val} <- maybe,
         {:just, innerVal} <- fun.(val) do
      {:just, innerVal}
    else
      _ -> :nothing
    end
  end

  @doc """
  determines if a value is a maybe type

  ## Examples
  iex> Maybe.is_maybe({:just, 0})
  true

  iex> Maybe.is_maybe(:nothing)
  true

  iex> Maybe.is_maybe({:ok, 3})
  false
  """
  def is_maybe(maybe) do
    case maybe do
      {:just, _} -> true
      :nothing -> true
      _ -> false
    end
  end

  @doc """
  converts a variable that might be nil to a maybe type

  ## Examples
  iex> Maybe.from_nilable("khajiit has wares")
  {:just, "khajiit has wares"}

  iex> Maybe.from_nilable(nil)
  :nothing
  """
  def from_nilable(val) do
    cond do
      is_nil(val) -> :nothing
      true -> just(val)
    end
  end

  @doc """
  converts a variable from a result type to a maybe type

  ## Examples
  iex> Maybe.from_result({:ok, 3})
  {:just, 3}

  iex> Maybe.from_result({:error, "I took an arrow to the knee"})
  :nothing
  """
  def from_result(result) do
    case result do
      {:ok, val} -> {:just, val}
      _ -> :nothing
    end
  end

  @doc """
  converts a variable from a validation type to a maybe type

  ## Examples
  iex> Maybe.from_validation({:success, "Dragon Slayed"})
  {:just, "Dragon Slayed"}

  iex> Maybe.from_result({:fail, ["You Died"]})
  :nothing
  """
  def from_validation(result) do
    case result do
      {:success, val} -> {:just, val}
      _ -> :nothing
    end
  end
end
