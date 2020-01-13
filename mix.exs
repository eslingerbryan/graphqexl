defmodule Graphqexl.MixProject do
  use Mix.Project

  @version '0.1.0'

  def project do
    [
      app: :graphqexl,
      version: @version |> to_string,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        stable: [
          include_executables_for: [:unix],
          applications: [graphqexl: :permanent, runtime_tools: :permanent],
        ],
      ],
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      description: 'Fully-loaded, pure-Elixir GraphQL server implementation with developer tools',
      mod: {Graphqexl.Application, []},
      extra_applications: [:logger, :runtime_tools],
      vsn: @version,
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:authex, "~> 2.0"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:gettext, "~> 0.11"},
      {:inflex, "~> 2.0.0"},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.4.11"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    []
  end
end
