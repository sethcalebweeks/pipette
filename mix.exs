defmodule Pex.MixProject do
  use Mix.Project

  def project do
    [
      app: :pex,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: [
        main: "Pex",
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
    """
    Overides the default pipe operator with one that has automatic result tuple
    wrapping and unwrapping, piping into maps, lists, and specific parameter
    position, piping into function definition, skipping overerror tuples,
    transforming error tuples, catching thrown values, and rescuing exceptions.
    """
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{}
    ]
  end
end
