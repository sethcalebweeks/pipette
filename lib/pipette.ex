defmodule Pipette do

  @moduledoc """
  ## Usage

  Add `use Pipette` to the start of the module. This will introduce the `<~` and `~>` operators.

  ## Examples

  ### Normal pipe operation

      iex> %{hello: "world"} ~> Map.get(:hello)
      "world"

  ### Pipe into maps

      iex> "world" ~> %{hello: &1}
      %{hello: "world"}

      iex> :hello ~> %{&1 => "world"}
      %{hello: "world"}

  ### Pipe into lists

      iex> 2 ~> [1, &1, 3]
      [1, 2, 3]

      iex> 1 ~> [&1 | [2, 3]]
      [1, 2, 3]

      iex> [2, 3] ~> [1 | &1]
      [1, 2, 3]

  ### Pipe into a specific function parameter (instead of the first)

      iex> %{hello: "world"}
      ...> ~> Map.get(:hello)
      ...> ~> Map.put(%{}, :goodbye, &1)
      %{goodbye: "world"}

  ### Pipe into function definition

      iex> %{hello: "world"}
      ...> ~> Map.get(:hello)
      ...> ~> fn value -> "hello " <> value end
      "hello world"

  ### Skip over error tuples

      iex> {:error, "Something went wrong"}
      ...> ~> Map.get(:hello)
      ...> ~> Map.put(%{}, :goodbye, &1)
      {:error, "Something went wrong"}

  ### Transform error tuples (with `<~`)

      iex> assert {:error, "Something went wrong"}
      ...> ~> Tuple.to_list
      ...> <~ fn error -> error <> ", more information" end
      {:error, "Something went wrong, more information"}

      iex> {:error, "Something went wrong"}
      ...> <~ fn _ -> {:ok, "Default value"} end
      "Default value"

  ### Inspect both result tuples (with simplified labels)

      iex> ExUnit.CaptureIO.capture_io(fn ->
      ...>  {:error, "Something went wrong"}
      ...>  ~> IO.inspect                      # Without label
      ...>  <~ fn _ -> {:ok, "Default value"} end
      ...>  ~> IO.inspect("ok")                # With label
      ...> end)
      \"""
      {:error, "Something went wrong"}
      ok: "Default value"
      \"""

  """

  defmacro __using__(_opts) do
    quote do
      import Pipette.Macros
    end
  end
end
