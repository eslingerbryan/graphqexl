alias Graphqexl.Query
alias Graphqexl.Query.{
  Operation,
  ResultSet,
}
alias Graphqexl.Schema

defmodule Graphqexl.QueryTest do
  use ExUnit.Case

  @query """
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

  @expected_query %Query{
    operations: [
      %Operation{
        name: :getPost,
        arguments: %{
          id: :postId
        },
        fields: %Treex.Tree{
          value: :root,
          children: [
            %Treex.Tree{
              children: [
                %Treex.Tree{
                  children: [],
                  value: :firstName,
                },
                %Treex.Tree{
                  children: [],
                  value: :lastName,
                }
              ],
              value: :author,
            },
            %Treex.Tree{
              children: [
                %Treex.Tree{
                  children: [
                    %Treex.Tree{
                      children: [],
                      value: :firstName,
                    },
                    %Treex.Tree{
                      children: [],
                      value: :lastName,
                    },
                  ],
                  value: :author,
                },
                %Treex.Tree{
                  children: [],
                  value: :text,
                }
              ],
              value: :comments,
            },
            %Treex.Tree{
              children: [],
              value: :text,
            },
            %Treex.Tree{
              children: [],
              value: :title,
            },
          ],
        },
        type: :query,
        user_defined_name: :getSinglePost,
        variables: %{
          postId: "foo",
        }
      },
    ]
  }

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
  """ |> Schema.gql

  test "execute" do
    assert @expected_query |> Query.execute(@schema) == %ResultSet{}
  end

  test "parse" do
    assert @query |> Query.parse == @expected_query
  end
end
