defmodule VoteNerd.Mixfile do
  use Mix.Project

  def project do
    [
      app: :vote_nerd,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
    ]
  end

  def application do
    [
      mod: {VoteNerd, []},
      applications: [:nadia],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nadia, github: "dotboris/nadia", branch: "remove-nil-values-in-markup"},
      {:excoveralls, "~> 0.6", only: :test},
      {:credo, "~> 0.7", only: [:dev, :test], runtime: false}
    ]
  end
end
