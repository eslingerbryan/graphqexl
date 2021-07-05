alias Graphqexl.Schema.{
  Field,
  Interface,
  Ref,
  Type,
  TEnum,
  Union,
}

defmodule Graphqexl.Schema.RefTest do
  @schema %Graphqexl.Schema{
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
      },
      Contact: %Graphqexl.Schema.Union{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        name: :Content,
        type1: %Graphqexl.Schema.Ref{type: :Email},
        type2: %Graphqexl.Schema.Ref{type: :Phone}
      },
      AplusB: %Graphqexl.Schema.Union{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        name: :Content,
        type1: %Graphqexl.Schema.Ref{type: :A},
        type2: %Graphqexl.Schema.Ref{type: :B}
      },
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
            required: true,
            type: %Graphqexl.Schema.Ref{type: :Id}
          },
          text: %Graphqexl.Schema.Argument{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :text,
            required: true,
            type: %Graphqexl.Schema.Ref{type: :String}
          },
          title: %Graphqexl.Schema.Argument{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :title,
            required: false,
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
            required: true,
            type: %Graphqexl.Schema.Ref{type: :Id}
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
            required: true,
            type: %Graphqexl.Schema.Ref{type: :Id}
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
            required: false,
            value: %Graphqexl.Schema.Ref{type: :User}
          },
          comments: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :comments,
            required: false,
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
            required: false,
            value: %Graphqexl.Schema.Ref{type: :String}
          },
          title: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :title,
            required: false,
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
            value: %Graphqexl.Schema.Ref{type: :Id}
          },
          author: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :author,
            required: false,
            value: %Graphqexl.Schema.Ref{type: :User}
          },
          parent: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :parent,
            required: false,
            value: %Graphqexl.Schema.Ref{type: :Content}
          },
          text: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :text,
            required: false,
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
            required: true,
            value: %Graphqexl.Schema.Ref{type: :Id}
          },
          email: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :email,
            required: false,
            value: %Graphqexl.Schema.Ref{type: :String}
          },
          firstName: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :firstName,
            required: false,
            value: %Graphqexl.Schema.Ref{type: :String}
          },
          lastName: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :lastName,
            required: false,
            value: %Graphqexl.Schema.Ref{type: :String}
          },
          role: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :role,
            required: false,
            value: %Graphqexl.Schema.Ref{type: :Role}
          },
          comments: [%Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :comments,
            required: false,
            value: %Graphqexl.Schema.Ref{type: :Comment}
          }]
        },
        name: :User
      },
      A: %Graphqexl.Schema.Type{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        fields: %{
          fromA: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :fromA,
            required: false,
            value: :String
          },
        },
        name: :A
      },
      B: %Graphqexl.Schema.Type{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        fields: %{
          fromA: %Graphqexl.Schema.Field{
            deprecated: false,
            deprecation_reason: "",
            description: "",
            name: :fromB,
            required: false,
            value: :String
          },
        },
        name: :B
      },
      Datetime: %Graphqexl.Schema.Type{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        fields: %{},
        implements: %Graphqexl.Schema.Ref{type: :String},
        name: :Datetime
      },
      Email: %Graphqexl.Schema.Type{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        fields: %{},
        implements: %Graphqexl.Schema.Ref{type: :String},
        name: :Email
      },
      Phone: %Graphqexl.Schema.Type{
        deprecated: false,
        deprecation_reason: "",
        description: "",
        fields: %{},
        implements: %Graphqexl.Schema.Ref{type: :String},
        name: :Phone
      }
    }
  }
  
  use ExUnit.Case

  describe "when the ref is an enum" do
    test "fields" do
      assert %Ref{type: :Role} |> Ref.fields(@schema) == []
    end

    test "resolve" do
      assert %TEnum{name: :Role} = %Ref{type: :Role} |> Ref.resolve(@schema)
    end

    test "scalar?" do
      assert %Ref{type: :Role} |> Ref.scalar?(@schema) == true
    end
  end

  describe "when the ref is a built in scalar type" do
    test "fields" do
      assert %Ref{type: :String} |> Ref.fields(@schema) == []
    end

    test "resolve" do
      assert %Ref{type: :String} |> Ref.resolve(@schema) == :String
    end

    test "scalar?" do
      assert %Ref{type: :String} |> Ref.scalar?(@schema) == true
    end
  end

  describe "when the ref is an interface" do
    test "fields" do
      fields = [
        %Field{name: :createdAt, value: %Ref{type: :Datetime}},
        %Field{name: :updatedAt, value: %Ref{type: :Datetime}},
      ]
      assert %Ref{type: :Timestamped} |> Ref.fields(@schema) == fields
    end

    test "resolve" do
      assert %Interface{name: :Timestamped} = %Ref{type: :Timestamped} |> Ref.resolve(@schema)
    end

    test "scalar?" do
      assert %Ref{type: :Timestamped} |> Ref.scalar?(@schema) == false
    end
  end

  describe "when the ref is an object Type" do
    test "fields" do
      # TODO: how can this test not depend on order?
      fields = [
        %Field{name: :createdAt, value: %Ref{type: :Datetime}},
        %Field{name: :updatedAt, value: %Ref{type: :Datetime}},
        %Field{name: :comments, value: %Ref{type: :Comment}},
        %Field{name: :email, value: %Ref{type: :String}},
        %Field{name: :firstName, value: %Ref{type: :String}},
        %Field{name: :id, required: true, value: %Ref{type: :Id}},
        %Field{name: :lastName, value: %Ref{type: :String}},
        %Field{name: :role, value: %Ref{type: :Role}},
      ]
      assert %Ref{type: :User} |> Ref.fields(@schema) == fields
    end

    test "resolve" do
      assert %Type{name: :User} = %Ref{type: :User} |> Ref.resolve(@schema)
    end

    test "scalar?" do
      assert %Ref{type: :User} |> Ref.scalar?(@schema) == false
    end
  end

  describe "when the ref is a custom scalar type" do
    test "fields" do
      assert %Ref{type: :Datetime} |> Ref.fields(@schema) == []
    end

    test "resolve" do
      assert %Type{name: :Datetime} = %Ref{type: :Datetime} |> Ref.resolve(@schema)
    end

    test "scalar?" do
      assert %Ref{type: :Datetime} |> Ref.scalar?(@schema) == true
    end
  end

  describe "when the ref is a union type" do
    test "fields" do
      fields = [
        %Field{name: :fromA, value: :String},
        %Field{name: :fromB, value: :String},
      ]
      assert %Ref{type: :AplusB} |> Ref.fields(@schema) == fields
    end

    test "resolve" do
      assert %Union{name: :Content} = %Ref{type: :Content} |> Ref.resolve(@schema)
    end
  end

  describe "when the ref is a union of scalar types" do
    test "scalar?" do
      assert %Ref{type: :Contact} |> Ref.scalar?(@schema) == true
    end
  end

  describe "when the ref is a union of non-scalar types" do
   test "scalar?" do
     assert %Ref{type: :Content} |> Ref.scalar?(@schema) == false
   end
  end
end
