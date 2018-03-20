defmodule Moonsugar.MixProject do
  use Mix.Project

  def project do
    [
      app: :moonsugar,
      version: "0.1.2",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Addictive utility functions for elixir style data structures",
      package: [
        name: "moonsugar",
        licenses: ["MIT"],
        maintainers: ["bcoop713@gmail.com"],
        links: %{"Github" => "https://github.com/bcoop713/moonsugar"}
      ]

    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
