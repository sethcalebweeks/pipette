defmodule Pipette.Macros do

  alias Pipette.Either

  @value {:__VALUE__, [], __MODULE__}

  defmacrop _(), do: quote([do: {:&, _, [1]}])

  # Pipe into map
  defmacro left |> {:%{}, meta, args} do
    args = Enum.map(args, fn
      {_(), _()} -> {left, left};
      {_(), value} -> {left, value};
      {key, _()} -> {key, left};
      x -> x
    end)
    quote do
      unquote({:ok, {:%{}, meta, args}})
    end
  end

  # Pipe into list head or tail
  defmacro left |> [{:|, _, [_(), tail]}], do: {:ok, [left | tail]}
  defmacro left |> [{:|, _, [head, _()]}] do
    quote do
      {:ok, [unquote(head) | unquote(left)]}
    end
  end

  # Pipe into list position
  defmacro left |> right when is_list(right) do
    IO.inspect(right)
    {:ok, Enum.map(right, fn
      _() -> left;
      x -> x
    end)}
  end

  # Pipe into function defintion
  defmacro left |> ({:fn, meta, _} = fun), do:
    either(:right, left, {{:., meta, [fun]}, meta, []})

  # Pipe into inspect with label
  defmacro left |> {{:., meta_start, [aliases, :inspect]}, meta_end, args} do
    label = if(length(args) == 1, do: [label: Enum.at(args, 0)], else: [])
    quote do
      unquote({{:., meta_start, [aliases, :inspect]}, meta_end, [left, label]})
    end
  end

  # Default pipe definition
  defmacro left |> right, do: either(:right, left, right)

  # Pipe errors into function defintion
  defmacro left <~ ({:fn, meta, _} = fun), do:
    either(:left, left, {{:., meta, [fun]}, meta, []})

  # Pipe errors to function
  defmacro left <~ right, do: either(:left, left, right)

  # Simple lambdas
  defmacro ({_, meta, _} = left) ~> right do
    quote do
      unquote({:fn, meta, [{:->, meta, [
        [left],
        right
      ]}]})
    end
  end

  defp place_arg([]), do: [@value]
  defp place_arg(args), do: place_arg(args, false) || [@value | args]
  defp place_arg([], true), do: []
  defp place_arg([], false), do: false
  defp place_arg([_() | tail], _), do: [@value | place_arg(tail, true)]
  defp place_arg([head | tail], match), do: (tail = place_arg(tail, match)) && [head | tail]

  defp either(side, left, {call, meta, args}) do
    quote do
      apply(Either, unquote(side), [
        unquote(left),
        fn unquote(@value) -> unquote({call, meta, place_arg(args)}) end
      ])
    end
  end

end
