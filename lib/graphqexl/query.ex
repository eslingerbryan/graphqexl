alias Graphqexl.Query.{
  Operation,
  ResultSet,
  Validator,
}
alias Graphqexl.Schema
alias Treex.{
  Traverse,
  Tree,
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
    |> Enum.reduce(%{stack: [], current: nil, fields: [], operations: []}, &tokenize/2)
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
  def tokenize(line, %{stack: stack, current: current, fields: fields, operations: operations}) do
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
        firstName: %{}
        lastName: %{}
      },
      comments: %{
        author: %{
          firstName: %{}
          lastName: %{}
        },
        text: %{}
      },
      title: %{}
      text: %{}
    }
    """
    case line |> String.at(-1) do
      @opening_brace ->
        if is_nil(current) do
          {stack, line |> new_operation(current), [], operations}
        else
          {stack |> stack_push([]), current, fields |> stack_push(line |> new_field), operations}
        end

      @closing_brace ->
        {current_fields, remaining} = stack |> stack_pop

        if remaining |> Enum.empty? do
          {top, rest} = fields |> stack_pop
          new_top = {top |> elem(0), current_fields}
          new_fields = rest |> stack_push(new_top)

          {remaining, current, new_fields, operations}
        else
          new_operations =
            operations
            |> stack_push(
              fields
              |> Enum.reduce(current, &(Operation.add_field(&2, &1)))
            )

          {stack, nil, [], new_operations}
        end

      _ ->
        {top, remaining} = stack |> stack_pop
        new_top = top |> stack_push(line |> new_field)

        {remaining |> stack_push(new_top), current, fields, operations}
    end
  end

  @doc false
  defp new_field(line) do
    {
      line |> String.trim |> String.to_atom,
      %{}
    }
  end

  @doc false
  defp new_operation(line, current) do
    %{type: type, name: name, arguments: arguments} =
      @operation_pattern |> Regex.named_captures(line)

    %Operation{
      type: type |> String.to_atom,
      name: name,
      arguments: arguments |> tokenize_arguments,
      fields: %{}
    }
  end

  @doc false
  defp tokenize_arguments(arguments) do
    arguments
    |> String.replace(@close_argument, "")
    |> String.replace(@open_argument, "")
    |> String.split("\n")
    |> Enum.map(&(
      %{
        name: String.split(&1, ":") |> elem(0),
        value: String.split(&1, ":") |> elem(1)
      }
    ))
  end

  @doc false
  defp stack_pop(stack) do
    stack |> List.pop_at(0)
  end

  @doc false
  defp stack_push(stack, value) do
    stack |> List.insert_at(0, value)
  end

  @doc false
  defp validate!(query, schema) do
    true = query |> Validator.valid?(schema)
  end
end
