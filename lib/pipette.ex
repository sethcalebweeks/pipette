defmodule Pipette do
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [|>: 2]
      import Pipette.Macros
    end
  end
end
