alias Graphqexl.Schema.{
  Field,
  Interface,
  Ref,
  Required,
  TEnum,
  Type,
  Union,
}

defmodule Graphqexl.Schema.SchemaTest do
  use ExUnit.Case

  test "gql" do
    input =
      """
      # comments don't count

      interface Timestamped {
        createdAt: Datetime
        updatedAt: Datetime
      }

      type Datetime = String

      type User implements Timestamped {
        id: Id!
        firstName: String
        lastName: String
        email: String
        role: Role
      }

      type Comment implements Timestamped {
        id: Id!
        author: User
        parent: Content
        text: String
      }

      type Post implements Timestamped {
        id: Id!
        text: String
        title: String
        author: User
        comments: [Comment]
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
        query: Query
        mutation: Mutation
      }
      """

    expected =
      %Graphqexl.Schema{
        str: """
        interface Timestamped, fields: %{createdAt: Datetime, updatedAt: Datetime}
        type Datetime, String
        type User, implements: Timestamped, fields: %{id: Id!, firstName: String, lastName: String, email: String, role: Role}
        type Comment, implements: Timestamped, fields: %{id: Id!, author: User, text: String}
        type Post, implements: Timestamped, fields: %{id: Id!, author: User, text: String, title: String}
        union Content, Comment, Post
        enum Role, [:AUTHOR, :EDITOR, :ADMIN]
        Query { getPost(id: Id!): Post, getUserComments(userId: Id!): [Comment] }
        Mutation { createPost(title: String, text: String!), authorId: Id!): Post }
        schema, fields: %{query: Query, mutation: Mutation}
        """,
        enums: [
          %TEnum{
            name: "Role",
            values: [:AUTHOR, :EDITOR, :ADMIN]
          },
        ],
        interfaces: [
          %Interface{
            name: "Timestamped",
            fields: %{
              createdAt: %Field{
                name: :createdAt,
                value: %Ref{type: :Datetime}
              },
              updatedAt: %Field{
                name: :updatedAt,
                value: %Ref{type: :Datetime}
              }
            }
          },
        ],
        queries: [],
        mutations: [],
        subscriptions: [],
        types: [
          %Type{name: "Datetime", implements: :String},
          %Type{
            name: "User",
            implements: [
              %Ref{type: :Timestamped},
            ],
            fields: [
              %Required{
                type: %Field{name: "id", value: :Id}
              },
              %Field{name: "email", value: :String},
              %Field{name: "firstName", value: :String},
              %Field{name: "lastName", value: :String},
              %Field{
                name: "role",
                value: %Ref{type: :Role}
              },
            ]
          },
          %Type{
            name: "Comment",
            implements: [
              %Ref{type: :Timestamped},
            ],
            fields: [
              %Required{
                type: %Field{name: "id", value: :Id}
              },
              %Field{
                name: "author",
                value: %Ref{type: :User}
              },
              %Field{
                name: "parent",
                value: %Ref{type: :Content}
              },
              %Field{name: "text", value: :String},
            ]
          },
          %Type{
            name: "Post",
            implements: [
              %Ref{type: :Timestamped},
            ],
            fields: [
              %Required{
                type: %Field{name: "id", value: :Id}
              },
              %Field{name: "title", value: :String},
              %Field{name: "text", value: :String},
              %Field{
                name: "author",
                value: %Ref{type: :User}
              },
              %Field{
                name: "comments",
                value: [
                  %Ref{type: :Comment}
                ]
              },
            ]
          },
        ],
        unions: [
          %Union{
            name: "Content",
            type1: %Ref{type: :Comment},
            type2: %Ref{type: :Post},
          }
        ]
      }
      true
#    assert Graphqexl.Schema.gql(input) == expected
  end
end
