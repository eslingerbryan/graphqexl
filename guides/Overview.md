# GraphQExL

Fully-loaded GraphQL implementation with server and developer tools.

## Schema
Schemas can be expressed as `t:Graphqexl.Schema.gql/0` DSL syntax, a JSON document, or by building up a 
`t:Graphqexl.Schema.t/0` struct via calls to `Graphql.Schema.register/2`.

## Resolvers
Resolvers are functions that are invoked to fulfill query executions. They can take parameters, as 
expressed as query arguments in the schema, and must return a type coercible to the type specified 
in the schema.
