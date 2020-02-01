alias Graphqexl.Schema.{
  Field,
  Interface,
  Ref,
  Required,
  TEnum,
  Type,
  Union
}

defmodule Graphqexl.Server.Router do
  use Plug.Router
  require Logger

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass: ["text/*"],
                     json_decoder: Jason
  plug :dispatch

  def fake_resolver(_, _, _) do
    []
  end

  @resolvers %{
    getPosts: &Graphqexl.Server.Router.fake_resolver/3
  }

  @schema %Graphqexl.Schema{
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

  get "/graphql" do
    Logger.debug("Starting request: #{conn |> request_log_str}")
    Logger.info("Finished request: #{conn |> request_log_str}")
    Graphqexl.Server.Plug.call(conn, Graphqexl.Server.Plug.init([]))
  end

  post "/graphql", assigns: %{schema: @schema} do
    Logger.debug("Starting request: #{conn |> request_log_str}")
    Logger.info("Finished request: 200 #{conn |> request_log_str}")
    Graphqexl.Server.Plug.call(conn, Graphqexl.Server.Plug.init([]))
  end

  match _ do
    Logger.debug("Starting request: #{conn |> request_log_str}")
    Logger.info("Finished request: #{conn |> request_log_str}")
    send_resp(conn, 404, "oops")
  end

  defp request_log_str(conn) do
    "[#{conn.method |> String.upcase}] #{conn.request_path}"
  end
end
