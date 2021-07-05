alias Graphqexl.Schema.Dsl

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

      type Query {
        getPost(id: Id!): Post
        getUserComments(userId: Id!): [Comment]
      }

      type Mutation {
        createPost(title: String, text: String!, authorId: Id!): Post
      }

      schema {
        query:    Query


        mutation:     Mutation
      }
      """

    expected =
      """
interface Timestamped createdAt:Datetime updatedAt:Datetime
type Datetime ^String
type User Timestamped firstName:String lastName:String email:String role:Role
union Content Comment Post
enum Role AUTHOR EDITOR ADMIN
type Query getPost(id:Id!):Post getUserComments(userId:Id!):[Comment]
type Mutation createPost(title:String text:String! authorId:Id!):Post
schema query:Query mutation:Mutation
"""
    assert Dsl.preprocess(input) == (expected |> String.trim)
  end
end
