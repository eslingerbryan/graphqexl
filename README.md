# Graphqexl

CircleCI (master): [![CircleCI](https://circleci.com/gh/eslingerbryan/graphqexl.svg?style=svg)](https://app.circleci.com/github/eslingerbryan/graphqexl/pipelines)

Graphqexl is a fully-loaded GraphQL implementation along with server utilities and developer tools.

## Schema
Schemas can be expressed as `gql` DSL syntax, a JSON document, or by building up a %Graphqexl.Schema 
struct via calls to `Graphql.Schema.register/2`.

## Resolvers
Resolvers are functions that are invoked to fulfill query executions. They can take parameters, as 
expressed as query arguments in the schema, and must return a type coercible to the type specified 
in the schema.

## Installation

The package can be installed by adding `graphqexl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:graphqexl, "~> 0.1.0"}
  ]
end
```

## Support / Maintenance

`graphqexl` uses Semantic Versioning, contained in a `VERSION` file. During the 0.X release series, we will support 2 minor versions back from the current at any given time. For example, if the current latest release is 0.4, we will also support 0.3 and 0.2, but not 0.1.

On the 1.Y and greater tracks, we will support one minor version at a time of one major version back from the current. For example, if the latest release is 2.3 and there was a 1.7 release and 0.9 release, we will support 2.3 and 1.7, but not 2.2, 1.6, or 0.9.

## Development

### Requirements
1. Elixir 1.9+ / Erlang 22+: `brew install erlang elixir` / `apt-get install erlang elixir`
1. Hex: `mix local.hex`
1. Mix Dependencies: `mix deps.get` (and optionally `mix deps.compile`)

TODO: Contributing

### Git Branching
Branches should follow `git-flow` conventions.

#### master
`master` is the current, latest stable release. There will be a corresponding tag for the version. This is what is published to Hex.

#### develop
`develop` is the primary branch, and is what will be deployed to staging environments.

#### feature branches
Feature branches are primarily what developers work on and are prefixed with `feature/`. They are cut from `develop` and merge back into `develop`. Developers should rebase feature branches frequently against `develop`.

#### release branches
Release branches are cut from `develop` and merged into `master`, which is then back-merged into `develop`. The `VERSION` file will be incremented in these branches, and contain one or more feature branches ready to be released.

#### hotfix branches
Hotfix branches are Z-version patch updates containing critical or non-critical bug and security fixes. They may also contain dependency updates. These branches are prefixed `hotfix/` and named for their version. The `VERSION` file will be updated in these branches. Hotfix branches are cut from `master`, merged into `master` and then `master` is back-merged into `develop` and any active release branches.

#### support branches
Support branches are cut from `master` before X-version major releases are made. See the Support/Maintenance section for more details on maintenance policies. Support branches are prefixed with `support/` and named for their X or X.Y track. They are versioned, tagged and published separately, almost like secondary "master"s. Release branches are merged into support branches as appropriate per the support track's status.

Documentation can be found at [https://hexdocs.pm/graphqexl](https://hexdocs.pm/graphqexl).

## References
- [GraphQL](https://www.graphql.org)
- [GraphQL Spec](https://spec.graphql.org/June2018/)