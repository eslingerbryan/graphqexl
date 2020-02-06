alias Treex.Tree

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
        context: nil,
        enums: %{
          Role: %Graphqexl.Schema.TEnum{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :Role,
            values: [:AUTHOR, :EDITOR, :ADMIN]
          }
        },
        interfaces: %{
          Timestamped: %Graphqexl.Schema.Interface{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            extend: nil,
            fields: %{
              createdAt: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :createdAt,
                value: %Graphqexl.Schema.Ref{type: :Datetime}
              },
              updatedAt: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :updatedAt,
                value: %Graphqexl.Schema.Ref{type: :Datetime}
              }
            },
            name: :Timestamped,
            on: []
          }
        },
        resolvers: %{},
        subscriptions: %{},
        unions: %{
          Content: %Graphqexl.Schema.Union{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :Content,
            type1: %Graphqexl.Schema.Ref{type: :Comment},
            type2: %Graphqexl.Schema.Ref{type: :Post}
          }
        },
        mutations: %{
          createPost: %Graphqexl.Schema.Mutation{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :createPost,
            return: %Graphqexl.Schema.Ref{type: :Post},
            arguments: %{
              authorId: %Graphqexl.Schema.Argument{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :authorId,
                type: %Graphqexl.Schema.Ref{
                  type: %Graphqexl.Schema.Required{type: :Id}
                }
              },
              text: %Graphqexl.Schema.Argument{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :text,
                type: %Graphqexl.Schema.Ref{
                  type: %Graphqexl.Schema.Required{type: :String}
                }
              },
              title: %Graphqexl.Schema.Argument{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :title,
                type: %Graphqexl.Schema.Ref{type: :String}
              }
            }
          }
        },
        queries: %{
          getUserComments: %Graphqexl.Schema.Query{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            arguments: %{
              userId: %Graphqexl.Schema.Argument{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :userId,
                type: %Graphqexl.Schema.Ref{
                  type: %Graphqexl.Schema.Required{type: :Id}
                }
              }
            },
            name: :getUserComments,
            return: [%Graphqexl.Schema.Ref{type: :Comment}]
          },
          getPost: %Graphqexl.Schema.Query{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            arguments: %{
              id: %Graphqexl.Schema.Argument{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :id,
                type: %Graphqexl.Schema.Ref{
                  type: %Graphqexl.Schema.Required{type: :Id}
                }
              }
            },
            name: :getPost,
            return: %Graphqexl.Schema.Ref{type: :Post}
          }
        },
        types: %{
          Post: %Graphqexl.Schema.Type{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            fields: %{
              author: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :author,
                value: %Graphqexl.Schema.Ref{type: :User}
              },
              comments: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :comments,
                value: [%Graphqexl.Schema.Ref{type: :Comment}]
              },
              id: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :id,
                value: %Graphqexl.Schema.Ref{
                  type: %Graphqexl.Schema.Required{type: :Id}
                }
              },
              text: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :text,
                value: %Graphqexl.Schema.Ref{type: :String}
              },
              title: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :title,
                value: %Graphqexl.Schema.Ref{type: :String}
              }
            },
            implements: %Graphqexl.Schema.Ref{type: :Timestamped},
            name: :Post
          },
          Comment: %Graphqexl.Schema.Type{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            implements: %Graphqexl.Schema.Ref{type: :Timestamped},
            fields: %{
              id: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :id,
                value: %Graphqexl.Schema.Ref{
                  type: %Graphqexl.Schema.Required{type: :Id}
                }
              },
              author: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :author,
                value: %Graphqexl.Schema.Ref{type: :User}
              },
              parent: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :parent,
                value: %Graphqexl.Schema.Ref{type: :Content}
              },
              text: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :text,
                value: %Graphqexl.Schema.Ref{type: :String}
              }
            },
            name: :Comment
          },
          User: %Graphqexl.Schema.Type{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            implements: %Graphqexl.Schema.Ref{type: :Timestamped},
            fields: %{
              id: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :id,
                value: %Graphqexl.Schema.Ref{
                  type: %Graphqexl.Schema.Required{type: :Id}
                }
              },
              email: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :email,
                value: %Graphqexl.Schema.Ref{type: :String}
              },
              firstName: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :firstName,
                value: %Graphqexl.Schema.Ref{type: :String}
              },
              lastName: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :lastName,
                value: %Graphqexl.Schema.Ref{type: :String}
              },
              role: %Graphqexl.Schema.Field{
                deprecated: false,
                deprecation_reason: "",
                description: "",
                name: :role,
                value: %Graphqexl.Schema.Ref{type: :Role}
              }
            },
            name: :User
          },
          Datetime: %Graphqexl.Schema.Type{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            fields: %Tree{},
            implements: %Graphqexl.Schema.Ref{type: :String},
            name: :Datetime
          }
        }
      }

    assert Graphqexl.Schema.gql(input) == expected
  end
end
