
defmodule Pipette.Macros do

  @moduledoc false

  alias Pipette.Result

  @value {:__VALUE__, [], __MODULE__}

  defmacrop _(), do: quote([do: {:&, _, [1]}])

  # ~> into inspect with label
  defmacro left ~> {{:., meta_start, [aliases, :inspect]}, meta_end, args} do
    label = if(length(args) == 1, do: [label: Enum.at(args, 0)], else: [])
    {{:., meta_start, [aliases, :inspect]}, meta_end, [left, label]}
  end

  # ~> skip over errors
  defmacro ({:error, _} = left) ~> _, do: left

  # ~> into map
  defmacro left ~> {:%{}, meta, args}, do: into_map(:ok, left, meta, args)

  # ~> into list
  defmacro left ~> right when is_list(right), do: into_list(:ok, left, right)

  # ~> into function defintion
  defmacro left ~> ({:fn, meta, _} = fun), do:
    result(:ok, left, {{:., meta, [fun]}, meta, []})

  # ~> default
  defmacro left ~> right, do: result(:ok, left, right)



  # <~ into map
  defmacro left <~ {:%{}, meta, args}, do: into_map(:error, left, meta, args)

  # <~ into list
  defmacro left <~ right when is_list(right), do: into_list(:error, left, right)

  # <~ into function defintion
  defmacro left <~ ({:fn, meta, _} = fun), do:
    result(:error, left, {{:., meta, [fun]}, meta, []})

  # <~ default
  defmacro left <~ right, do: result(:error, left, right)



  # Insert left side into map
  defp into_map(tag, left, meta, args) do
    left = Result.unwrap(tag, left)
    args = Enum.map(args, fn
      {_(), _()} -> {left, left};
      {_(), value} -> {left, value};
      {key, _()} -> {key, left};
      x -> x
    end)
    {:%{}, meta, args}
  end

  # Insert left side into list
  defp into_list(tag, left, [{:|, _, [_(), tail]}]), do:
    [Result.unwrap(tag, left) | tail]
  defp into_list(tag, left, [{:|, _, [head, _()]}]), do:
    [head | Result.unwrap(tag, left)]
  defp into_list(tag, left, right), do:
    Enum.map(right, fn _() -> Result.unwrap(tag, left); x -> x end)

  # Call the right side function with the left side argument
  defp result(tag, left, {call, meta, args}) do
    quote do
      apply(Result, unquote(tag), [
        unquote(left),
        fn unquote(@value) -> unquote({call, meta, place_arg(args)}) end
      ])
    end
  end

  # Place the argument at the start or by position
  defp place_arg([]), do: [@value]
  defp place_arg(args), do: place_arg(args, false) || [@value | args]
  defp place_arg([], true), do: []
  defp place_arg([], false), do: false
  defp place_arg([_() | tail], _), do: [@value | place_arg(tail, true)]
  defp place_arg([head | tail], match), do: (tail = place_arg(tail, match)) && [head | tail]

end
