defmodule Pex.Macros do

  @moduledoc false

  alias Pex.Result

  @value {:__VALUE__, [], __MODULE__}

  defmacrop _(), do: quote([do: {:&, _, [1]}])

  # Pipe into map
  defmacro left |> {:%{}, meta, args} do
    left = Result.unwrap(:ok, left)
    args = Enum.map(args, fn
      {_(), _()} -> {left, left};
      {_(), value} -> {left, value};
      {key, _()} -> {key, left};
      x -> x
    end)
    quote do
      {:ok, unquote({:%{}, meta, args})}
    end
  end

  # Pipe into list
  defmacro left |> [{:|, _, [_(), tail]}], do: {:ok, [Result.unwrap(:ok, left) | tail]}
  defmacro left |> [{:|, _, [head, _()]}], do:
    quote([do: {:ok, [unquote(head) | Result.unwrap(:ok, unquote(left))]}])
  defmacro left |> right when is_list(right), do:
    {:ok, Enum.map(right, fn _() -> Result.unwrap(:ok, left); x -> x end)}

  # Pipe into function defintion
  defmacro left |> ({:fn, meta, _} = fun), do:
    result(:ok, Result.unwrap(:ok, left), {{:., meta, [fun]}, meta, []})

  # Pipe into inspect with label
  defmacro left |> {{:., meta_start, [aliases, :inspect]}, meta_end, args} do
    label = if(length(args) == 1, do: [label: Enum.at(args, 0)], else: [])
    quote do
      unquote({{:., meta_start, [aliases, :inspect]}, meta_end, [left, label]})
    end
  end

  # Default pipe definition
  defmacro left |> right, do: result(:ok, left, right)

  # Pipe errors into function defintion
  defmacro left <~ ({:fn, meta, _} = fun), do:
    result(:error, left, {{:., meta, [fun]}, meta, []})

  # Pipe errors to function
  defmacro left <~ right, do: result(:error, left, right)

  defp place_arg([]), do: [@value]
  defp place_arg(args), do: place_arg(args, false) || [@value | args]
  defp place_arg([], true), do: []
  defp place_arg([], false), do: false
  defp place_arg([_() | tail], _), do: [@value | place_arg(tail, true)]
  defp place_arg([head | tail], match), do: (tail = place_arg(tail, match)) && [head | tail]

  defp result(side, left, {call, meta, args}) do
    quote do
      apply(Result, unquote(side), [
        unquote(left),
        fn unquote(@value) -> unquote({call, meta, place_arg(args)}) end
      ])
    end
  end

end
