defmodule BookshelfBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :bookshelfbot,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {BookshelfBot.Application, []}
    ]
  end

  defp deps do
    [
      {:nostrum, "~> 0.4.6"},
      {:tesla, "~> 1.4.1"},
      {:hackney, "~> 1.17.4"},
      {:jason, "~> 1.2.2"},
      {:cachex, "~> 3.4.0"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end
end
