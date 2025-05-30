defmodule Vancouver.MixProject do
  use Mix.Project

  def project do
    [
      app: :vancouver,
      version: "0.1.0",
      elixir: "~> 1.18",
      description: description(),
      package: package(),
      deps: deps(),
      name: "Vancouver",
      source_url: "https://github.com/jameslong/vancouver",
      docs: &docs/0
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
      {:ex_doc, "~> 0.38", only: :dev, runtime: false},
      {:ex_json_schema, "~> 0.11.0"},
      {:plug, "~> 1.15"}
    ]
  end

  defp description do
    "Quickly add Model Context Protocol (MCP) functionality to your Phoenix/Bandit server."
  end

  defp package() do
    [
      maintainers: ["James Long"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jameslong/vancouver"},
      files: ~w(lib priv mix.exs README.md LICENSE)
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
