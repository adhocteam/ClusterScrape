defmodule ClusterScrape.Mixfile do
  use Mix.Project

  def project do
    [app: :cluster_scrape,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     dialyzer: [plt_add_deps: :transitive, plt_add_apps: [:mix], flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs]]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {ClusterScrape, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext, :hackney, :httpoison, :floki, :peerage, :ex_aws]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.4"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:floki, "~> 0.17.0"},
     {:httpoison, "~> 0.12"},
     {:poison, "~> 1.5.0", override: true},
     {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
     {:distillery, "~> 1.4", runtime: false},
     {:peerage, "~> 1.0.2"},
     {:ex_aws, "~> 1.0"}]
  end
end
