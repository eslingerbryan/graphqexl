defmodule Graphqexl.Schema.DslTest do
  use ExUnit.Case

  test "preprocess" do
    input =
      """
      # comments don't count

      interface Timestamped {
        createdAt: Datetime,
        updatedAt: Datetime
      }

      type Datetime = String

      type User implements Timestamped {
        firstName: String
        lastName: String
        email: String
        role: Role
      }

      union Content = Comment | Post

      enum Role {
        AUTHOR,
        EDITOR,
        ADMIN,
      }

      schema {
        query:    Query


        mutation:     Mutation
      }
      """

    expected =
      """
      interface Timestamped, fields: %{createdAt: Datetime, updatedAt: Datetime}
      type Datetime, String
      type User, implements: Timestamped, fields: %{firstName: String, lastName: String, email: String, role: Role}
      union Content, Comment, Post
      enum Role, [:AUTHOR, :EDITOR, :ADMIN]
      schema, fields: %{query: Query, mutation: Mutation}
      """

    assert Graphqexl.Schema.Dsl.preprocess(input) == expected |> String.trim
  end
end
