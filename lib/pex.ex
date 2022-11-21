defmodule Pex do

  @moduledoc """
  This is how to use Pex

  ## Examples

  ### Automatic result tuples

      iex> %{hello: "world"} |> Map.get(:hello)
      {:ok, "world"}

  ### Pipe into maps

      iex> "world" |> %{hello: &1}
      {:ok, %{hello: "world"}}

      iex> :hello |> %{&1 => "world"}
      {:ok, %{hello: "world"}}

  ### Pipe into lists

      iex> 2 |> [1, &1, 3]
      {:ok, [1, 2, 3]}

      iex> 1 |> [&1 | [2, 3]]
      {:ok, [1, 2, 3]}

      iex> [2, 3] |> [1 | &1]
      {:ok, [1, 2, 3]}

  ### Pipe into a specific function parameter (instead of the first)

      iex> %{hello: "world"}
      ...> |> Map.get(:hello)
      ...> |> Map.put(%{}, :goodbye, &1)
      {:ok, %{goodbye: "world"}}

  ### Pipe into function definition

      iex> %{hello: "world"}
      ...> |> Map.get(:hello)
      ...> |> fn value -> "hello " <> value end
      {:ok, "hello world"}

  ### Skip over error tuples

      iex> {:error, "Something went wrong"}
      ...> |> Map.get(:hello)
      ...> |> Map.put(%{}, :goodbye, &1)
      {:error, "Something went wrong"}

  ### Transform error tuples (with `~>`)

      iex> assert {:error, "Something went wrong"}
      ...> |> Tuple.to_list
      ...> <~ fn error -> error <> ", more information" end
      {:error, "Something went wrong, more information"}

      iex> {:error, "Something went wrong"}
      ...> <~ fn _ -> {:ok, "recovered"} end
      ...> |> fn _ -> "hello world" end
      {:ok, "hello world"}

  ### Inspect both result tuples (with simplified labels)

      iex> ExUnit.CaptureIO.capture_io(fn ->
      ...>  {:error, "Something went wrong"}
      ...>  |> IO.inspect("error")             # With label
      ...>  <~ fn _ -> {:ok, "recovered"} end
      ...>  |> IO.inspect                      # Without label
      ...> end)
      \"""
      error: {:error, "Something went wrong"}
      {:ok, "recovered"}
      \"""

  ### Catch thrown values

      iex> %{hello: "world"}
      ...> |> Map.get(:hello)
      ...> |> fn _ -> throw("Something went wrong") end
      {:error, "Something went wrong"}

  ### Rescue exceptions

      iex> %{hello: "world"}
      ...> |> Map.get(:hello)
      ...> |> fn _ -> raise("Something went wrong") end
      {:error, %RuntimeError{message: "Something went wrong"}}

  """


  @spec __using__(any) :: {:__block__, [], [{:import, [...], [...]}, ...]}
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [|>: 2]
      import Pex.Macros
    end
  end
end
