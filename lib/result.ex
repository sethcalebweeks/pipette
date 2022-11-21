defmodule Pex.Result do

  @moduledoc false

  @spec ok(any, any) :: {:error, any} | {:ok, any}
  def ok({:error, _} = error, _fun), do: error
  def ok(value, fun) when is_function(fun, 1), do: result(:ok, value, fun)

  @spec error(any, any) :: {:error, any} | {:ok, any}
  def error({:error, error}, fun), do: result(:error, error, fun)
  def error(value, _fun), do: value

  defp result(tag, value, fun) do
    try do
      case fun.(unwrap(tag, value)) do
        {:ok, value} -> {:ok, value}
        {:error, value} -> {:error, value}
        value -> {tag, value}
      end
    rescue
      exception -> {:error, exception}
    catch
      error -> {:error, error}
    end
  end


  def unwrap(tag, value) do
    case value do
      {^tag, value} -> value
      value -> value
    end
  end


end
