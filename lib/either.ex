defmodule Pipette.Either do

  def right({:error, _} = error, _fun), do: error
  def right(value, fun) when is_function(fun, 1), do: either(:ok, value, fun)

  def left({:error, error}, fun), do: either(:error, error, fun)
  def left(value, _fun), do: value

  defp either(side, value, fun) do
    # Unwrap the value
    value = case value do
      {^side, value} -> value
      value -> value
    end
    try do
      # Rewrap the value
      case fun.(value) do
        {:ok, value} -> {:ok, value}
        {:error, value} -> {:error, value}
        value -> {side, value}
      end
    rescue
      exception -> {:error, exception}
    catch
      error -> {:error, error}
    end
  end

end
