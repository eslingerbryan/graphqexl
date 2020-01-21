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

## Development

### Requirements
1. Elixir 1.9+ / Erlang 22+: `brew install erlang elixir` / `apt-get install erlang elixir`
1. Hex: `mix local.hex`
1. Mix Dependencies: `mix deps.get` (and optionally `mix deps.compile`)

TODO: Contributing

Documentation can be found at [https://hexdocs.pm/graphqexl](https://hexdocs.pm/graphqexl).

## References
- [GraphQL](https://www.graphql.org)
- [GraphQL Spec](https://spec.graphql.org/June2018/)