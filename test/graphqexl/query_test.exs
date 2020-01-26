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
      # comments don't count
      query getSinglePost($postId: "foo") {
        getPost(id: $postId) {
          title
          text
          author {
            # comment can be anywhere
            firstName
            lastName
          }
          comments {
            author {
              firstName
              lastName
            }
            text
          }
        }
      }
      """

    expected = %Graphqexl.Query{
      operations: [
        %Operation{
          name: :getPost,
          arguments: %{
            id: :postId
          },
          fields: %{
            title: %{},
            text: %{},
            author: %{
              firstName: %{},
              lastName: %{},
            },
            comments: %{
              author: %{
                firstName: %{},
                lastName: %{},
              },
              text: %{},
            }
          },
          type: :query,
          user_defined_name: :getSinglePost,
          variables: %{
            postId: "foo",
          }
        },
      ]
    }

    assert Graphqexl.Query.parse(input) == expected
  end
end
