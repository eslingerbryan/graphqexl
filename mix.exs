defmodule Graphqexl.MixProject do
  use Mix.Project

  @version "VERSION" |> File.read! |> String.trim

  def project do
    [
      app: :graphqexl,
      version: @version,
      docs: docs(),
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        stable: [
          include_executables_for: [:unix],
          applications: [graphqexl: :permanent, runtime_tools: :permanent],
        ],
      ],
      description: "Fully-loaded, pure-Elixir GraphQL server implementation with developer tools",
      package: %{
        files: [
          "config",
          "lib",
          "priv",
          "mix.exs",
          "README*",
          "LICENSE*"
        ],
        licenses: ["MIT"],
        links: %{
          github: "https://github.com/eslingerbryan/graphqexl",
          graphql: "https://graphql.org/"
        }
      },
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
      vsn: @version |> to_charlist,
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
    ]
  end

  defp docs do
    [
      main: "overview",
      formatters: ["html", "epub"],
      extras: extras(),
      groups_for_extras: groups_for_extras()
    ]
  end

  defp extras do
    [
      "guides/Overview.md",
      "guides/Schema.md",
      "examples/Basic.md",
      "examples/SOA Orchestration.md",
    ]
  end

  defp groups_for_extras do
    [
      "Guides": ~r/guides\/[^\/]+\.md/,
      "Examples": ~r/examples\/[^\/]+\.md/,
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
