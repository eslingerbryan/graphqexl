alias Graphqexl.Query
alias Graphqexl.Query.{
  Operation,
  ResultSet,
}
alias Graphqexl.Schema
alias Graphqexl.Utils.FakeData

defmodule Graphqexl.QueryTest do
  use ExUnit.Case

  @post_id "efb97c69-f27e-49c5-b823-57a8a414ac1f"

  @query """
    # comments don't count
    query getSinglePost($postId: "#{@post_id}") {
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
          value: :getSinglePost,
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
        type: :Query,
        user_defined_name: :getSinglePost,
        variables: %{
          postId: "#{@post_id}",
        }
      },
    ]
  }

  # Internal Use Only
  defmodule Resolvers do
    @moduledoc false

    @doc false
    def create_post(_parent, _args, _context), do: FakeData.posts |> Enum.random

    @doc false
    def get_post(_parent, args, _context), do: args.id |> FakeData.post

    @doc false
    def get_user_comments(_parent, args, _context), do: args.userId |> FakeData.user_comments
  end

  @resolvers %{
    Query: %{
      getPost: &Graphqexl.QueryTest.Resolvers.get_post/3,
      getUserComments: &Graphqexl.QueryTest.Resolvers.get_user_comments/3,
    },
    Mutation: %{
      createPost: &Graphqexl.QueryTest.Resolvers.create_post/3,
    }
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
  """ |> Schema.executable(@resolvers)

  @expected_query_result %ResultSet{
    data: %{
      getSinglePost: %{
        title: "This is a cool post",
        author: %{firstName: "Testy", lastName: "McTesterson"},
        comments: [
          %{
            text: "Here is a comment",
            author: %{firstName: "Joe", lastName: "Schmoe"},
          },
          %{
            text: "Here is a second comment",
            author: %{firstName: "Jill", lastName: "Somebody"},
          },
        ],
        text: """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
        labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
        laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
        voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
        cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """,
      },
    },
    errors: %{},
  }

  test "execute" do
    assert @expected_query |> Query.execute(@schema) == @expected_query_result
  end

  test "parse" do
    assert @query |> Query.parse == @expected_query
  end
end
