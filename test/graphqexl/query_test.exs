alias Graphqexl.Query.Operation

defmodule Graphqexl.Schema.QueryTest do
  use ExUnit.Case

  @schema """
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

  test "parse" do
    input =
      """
      getPost(id: "foo") {
        title
        text
        author {
          name
        }
      }
      """

    expected = %Graphqexl.Query{
      operations: [
        %Operation{
          name: :getSinglePost,
          arguments: %{
            id: "foo"
          },
          fields: %{
            title: true,
            text: true,
            author: %{
              name: true,
            },
          },
        },
      ]
    }

    assert Graphqexl.Query.tokenize(input) == expected
  end
end
