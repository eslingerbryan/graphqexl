alias Graphqexl.Query.{
  Operation,
  ResultSet,
  Validator,
}
alias Graphqexl.Schema
alias Treex.{
  Traverse,
  Tree
}

defmodule Graphqexl.Query do
  @moduledoc """
  GraphQL query, comprised of one or more `t:Graphqexl.Query.Operation.t/0`s.

  Built by calling `parse/1` with either a `t:Graphqexl.Query.gql/0` string (see `Graphqexl.Schema.Dsl`)
  or `t:Graphqexl.Query.json/0`.
  """

  @type json :: Map.t
  @type gql :: String.t
  @type t :: %Graphqexl.Query{operations: [Operation.t]}

  defstruct operations: []

  @close_argument ")"
  @closing_brace "}"
  @comment_char "#"
  @delimiter ","
  @open_argument "("
  @opening_brace "{"

  @identifier "[_a-z][_a-zA-Z0-9]+"
  @operation_pattern ~r/(?<type>#{@identifier})?\s?(?<name>#{@identifier})\(?(?<fields>.*)\)?\s\{/

  @doc """
  Execute the given `t:Graphqexl.Query.t/0`

  Returns: `t:Graphqexl.Query.ResultSet.t/0`
  """
  @doc since: "0.1.0"
  @spec execute(Graphqexl.Query.t, Schema.t) :: ResultSet.t
  def execute(query, schema) do
    query |> validate!(schema)
    # build parent context
    # resolve resolver tree into %ResultSet{}
    # serialize into %Operation{}s
    # return %Query{operations: [<operations>]}
  end

  @doc """
  Parse the given gql string (see `Graphqexl.Schema.Dsl`) into a `t:Graphqexl.Query.t/0`

  Returns: `t:Graphqexl.Query.t/0`
  """
  @doc since: "0.1.0"
  @spec parse(gql) :: Query.t
  def parse(gql) when is_binary(gql) do
    gql
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&(String.replace(&1, "\n{", "{")))
    |> Enum.reduce(%{stack: [], operations: []}, &tokenize_operations/2)
  end

  @doc """
  Parse the given json map into a `t:Graphqexl.Query.t/0`

  Returns: `t:Graphqexl.Query.t/0`
  """
  @doc since: "0.1.0"
  @spec parse(json) :: Query.t
  def parse(_json) do
    # convert bare map to %Query{}
  end

  @doc false
  defp tokenize_operations(lines, %{stack: stack, operations: operations}) do
    %{type: type, name: name, arguments: arguments} =
      @operation_pattern |> Regex.named_captures(lines)
    operation = %Operation{
      type: type |> String.to_atom,
      name: name,
      arguments: arguments,
      fields: %{}
    }
    new_operation = operation |> Operation.add_field(lines |> String.trim |> String.to_atom)
  end

  @doc false
  def tokenize_arguments(line, %{stack: stack, fields: fields}) do


    {new_stack, new_fields} =
      if line |> String.starts_with?(@comment_char) do
        {stack, fields}
      else
        name =
          line
          |> String.replace(@opening_brace, "")
          |> String.trim
          |> String.to_atom
        case line |> String.at(-1) do
          @opening_brace ->
            """
            getPost(id: "foo") {
              author {
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
              title
              text
            }

            %{
              author: %{
                firstName: true
                lastName: true
              },
              comments: %{
                author: %{
                  firstName: true
                  lastName: true
                },
                text: true
              },
              title: true
              text: true
            }
            """
            {
              stack
              |> List.insert_at(0, %{
                name: name,
                value: true
              }),
              fields
            }

          @closing_brace ->
            {field, remaining} = stack |> List.pop_at(0)
            {remaining, fields |> List.insert_at(0, field)}

          _ ->
            {field, rest} = stack |> List.pop_at(0)
            new_field =
              field
              |> Map.update(
                   :value,
                   %{},
                   &(Map.update(&1, name, true, fn val -> val end))
                 )
            {stack |> List.insert_at(0, new_field), fields}
        end
      end

    %{stack: new_stack, fields: new_fields}
  end

  @doc false
  defp validate!(query, schema) do
    true = query |> Validator.valid?(schema)
  end
end
