defmodule Pipette.MixProject do
  use Mix.Project

  def project do
    [
      app: :pipette,
      version: "0.4.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: [
        main: "Pipette",
        api_reference: false
      ],
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "An alternative pipe operator for happy path programming."
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{}
    ]
  end
end
