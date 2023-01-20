defmodule Play do
  use Pipette

  def test() do
    %{hello: "world"} ~> Map.get(:hello)
  end

end
