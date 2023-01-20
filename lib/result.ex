defmodule Pipette.Result do

  @moduledoc false

  @spec ok(any, fun :: any) :: any
  def ok({:error, _} = error, _fun), do: error
  def ok(value, fun) when is_function(fun, 1) do
    fun.(unwrap(:ok, value))
  end

  @spec error(any, fun:: any) :: any
  def error({:error, error}, fun) do
    case fun.(unwrap(:error, error)) do
      {:ok, value} -> value
      {:error, value} -> value
      value -> {:error, value}
    end
  end
  def error(value, _fun), do: value

  @spec unwrap(:ok | :error, any) :: any
  def unwrap(tag, value) do
    case value do
      {^tag, value} -> value
      value -> value
    end
  end

end
