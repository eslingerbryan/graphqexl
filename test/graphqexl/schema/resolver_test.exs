alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Argument,
  Field,
  Interface,
  Mutation,
  Query,
  Ref,
  Resolver,
  TEnum,
  Type,
}
alias Treex.Tree

defmodule Graphqexl.Schema.ResolverTest do
  use ExUnit.Case

  @mutations %{
    createPost: %Mutation{
      deprecated: false,
      deprecation_reason: "",
      description: "",
      name: :createPost,
      return: %Ref{type: :Post},
      arguments: %{
        authorId: %Argument{
          deprecated: false,
          deprecation_reason: "",
          description: "",
          name: :authorId,
          required: true,
          type: %Ref{type: :Id}
        },
        text: %Argument{
          deprecated: false,
          deprecation_reason: "",
          description: "",
          name: :text,
          required: true,
          type: %Ref{type: :String}
        },
        title: %Argument{
          deprecated: false,
          deprecation_reason: "",
          description: "",
          name: :title,
          required: false,
          type: %Ref{type: :String}
        }
      }
    }
  }

  @queries %{
    getUserComments: %Query{
      deprecated: false,
      deprecation_reason: "",
      description: "",
      arguments: %{
        userId: %Argument{
          deprecated: false,
          deprecation_reason: "",
          description: "",
          name: :userId,
          required: true,
          type: %Ref{type: :Id},
        },
      },
      name: :getUserComments,
      return: [%Ref{type: :Comment}]
    },
    getPost: %Query{
      deprecated: false,
      deprecation_reason: "",
      description: "",
      arguments: %{
        id: %Argument{
          deprecated: false,
          deprecation_reason: "",
          description: "",
          name: :id,
          required: true,
          type: %Ref{type: :Id},
        },
      },
      name: :getPost,
      return: %Ref{type: :Post},
    },
  }

  @schema %Schema{
    tree: %Tree{
      value: :schema,
      children: [
        %Tree{
          value: :Query,
          children: [
            %Tree{value: :getPost, children: []},
            %Tree{value: :getUserComments, children: []},
          ]
        },
        %Tree{
          value: :Mutation,
          children: [%Tree{value: :createPost, children: []}]
        },
      ]
    },
    context: nil,
    enums: %{
      Role: %TEnum{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        name: :Role,
        values: [:AUTHOR, :EDITOR, :ADMIN]
      }
    },
    interfaces: %{
      Timestamped: %Interface{
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
    resolvers: %Tree{},
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
    mutations: @mutations,
    queries: @queries,
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
            required: true,
            value: %Graphqexl.Schema.Ref{type: :Id}
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
            required: true,
            value: %Ref{type: :Id}
          },
          author: %Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :author,
            value: %Ref{type: :User}
          },
          parent: %Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :parent,
            value: %Ref{type: :Content}
          },
          text: %Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :text,
            value: %Ref{type: :String}
          }
        },
        name: :Comment
      },
      User: %Type{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        implements: %Ref{type: :Timestamped},
        fields: %{
          id: %Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :id,
            required: true,
            value: %Ref{type: :Id}
          },
          email: %Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :email,
            value: %Ref{type: :String}
          },
          firstName: %Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :firstName,
            value: %Ref{type: :String}
          },
          lastName: %Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :lastName,
            value: %Ref{type: :String}
          },
          role: %Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :role,
            value: %Ref{type: :Role}
          }
        },
        name: :User
      },
      Datetime: %Type{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        fields: %{},
        implements: %Ref{type: :String},
        name: :Datetime
      }
    }
  }


  describe "when validating a tree of valid resolvers" do
    test "validate!" do
      func = fn(_, _, _) -> :resolved! end
      input = %Tree{
        value: :schema,
        children: [
          %Tree{
            value: :Query,
            children: [
              %Tree{value: %Resolver{for: :getUserComments, func: func}, children: []},
              %Tree{value: %Resolver{for: :getPost, func: func}, children: []},
            ]
          },
          %Tree{
            value: :Mutation,
            children: [%Tree{value: %Resolver{for: :createPost, func: func}}]
          }
        ]
      }

      assert input |> Resolver.validate!(@schema) == input
    end
  end

  describe "when validating a tree of invalid resolvers" do
    test "validate!" do
    end
  end

  test "tree_from_map" do
    func = fn(_, _, _) -> :resolved!  end

    input = %{
      Mutation: %{
        createPost: func,
      },
      Query: %{
        getPost: func,
        getUserComments: func,
      }
    }

    expected = %Tree{
      value: :schema,
      children: [
        %Tree{
          value: :Mutation,
          children: [
            %Tree{value: %Resolver{for: :createPost, func: func}, children: []}
          ]
        },
        %Tree{
          value: :Query,
          children: [
            %Tree{value: %Resolver{for: :getPost, func: func}, children: []},
            %Tree{value: %Resolver{for: :getUserComments, func: func}, children: []}
          ]
        }
      ]
    }
    assert input |> Resolver.tree_from_map(@schema, :schema) == expected
  end
end
