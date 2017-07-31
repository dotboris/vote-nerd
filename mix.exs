defmodule VoteNerd.Mixfile do
  use Mix.Project

  def project do
    [
      app: :vote_nerd,
      version: "0.1.0",
      elixir: "~> 1.5",
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
    app = [
      applications: [:nadia],
      extra_applications: [:logger]
    ]

    case Mix.env do
      :test -> app
      _ -> Keyword.put(app, :mod, {VoteNerd, []})
    end
  end

  defp deps do
    [
      {:nadia, github: "zhyu/nadia"},
      {:hackney, "1.6.5"}, # Fix hackney to 1.6.5 becuase 1.6.6 is retired
      {:excoveralls, "~> 0.6", only: :test},
      {:credo, "~> 0.7", only: [:dev, :test], runtime: false}
    ]
  end
end
