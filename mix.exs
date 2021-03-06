defmodule MetaInspector.Mixfile do
  use Mix.Project

  def project do
    [app: :meta_inspector,
     version: "0.0.2",
     elixir: "~> 1.2",
     description: "HTTP Metadata inspector",
     build_embedded: Mix.env == :prod,
     package: meta,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.8.0"},
     {:poison, "~> 2.0"}]
  end
  defp meta do
    [
      licenses: ["MIT"],
      contributors: ["Krzysztof Wende"]

    ]
  end
end
