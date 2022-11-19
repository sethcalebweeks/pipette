defmodule PipetteTest do
  use ExUnit.Case
  doctest Pipette

  use Pipette

  test "Normal pipe" do
    assert %{hello: "world"}
      |> Map.get(:hello)
    == {:ok, "world"}
  end

  test "Pipe into map" do
    # Pipe to value
    assert "world"
      |> %{hello: &1}
    == {:ok, %{hello: "world"}}
    # Pipe to key
    assert :hello
      |> %{&1 => "world"}
    == {:ok, %{hello: "world"}}
  end

  test "Pipe into list" do
    # Pipe to position in list
    assert 2
      |> [1, &1, 3]
    == {:ok, [1, 2, 3]}
    # Pipe to head of list
    assert 1
      |> [&1 | [2, 3]]
    == {:ok, [1, 2, 3]}
    # Pipe to tail of list
    assert [2, 3]
      |> [1 | &1]
    == {:ok, [1, 2, 3]}
  end

  test "Pipe to specific position" do
    assert %{hello: "world"}
      |> Map.get(:hello)
      |> Map.put(%{}, :goodbye, &1)
    == {:ok, %{goodbye: "world"}}
  end

  test "Pipe into function definition" do
    assert %{hello: "world"}
      |> Map.get(:hello)
      |> fn value -> "hello " <> value end
    == {:ok, "hello world"}
  end

  test "Ignore error tuples" do
    assert {:error, "Something went wrong"}
      |> Map.get(:hello)
      |> Map.put(%{}, :goodbye, &1)
    == {:error, "Something went wrong"}
  end

  test "Transform error tuples" do
    # Leave as error
    assert {:error, "Something went wrong"}
      |> Tuple.to_list
      <~ fn error -> error <> "\n More information" end
    == {:error, "Something went wrong\n More information"}
    # Recover to ok tuple
    assert {:error, "Something went wrong"}
      <~ fn _ -> {:ok, "recovered"} end
      |> fn _ -> "hello world" end
    == {:ok, "hello world"}
  end

  test "Inspect error and ok tuples" do
    assert {:error, "Something went wrong"}
      |> IO.inspect("error") # With label
      <~ fn _ -> {:ok, "recovered"} end
      |> IO.inspect # Without label
      |> fn _ -> "hello world" end
    == {:ok, "hello world"}
  end


end
