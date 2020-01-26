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
  @type_pattern "?<type>(query|mutation|subscription)"
  @name_pattern "?<name>#{@identifier}"
  @operation_pattern ~r/(#{@type_pattern})?\s?(#{@name_pattern})(?<arguments>\(?\(\$?.*\))?\s\{/

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
    operations =
      gql
      |> String.trim
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&(String.replace(&1, "\n{", "{")))
      |> Enum.reduce(%{stack: [], current: nil, operations: []}, &tokenize/2)
      |> Map.get(:operations)
    %Graphqexl.Query{operations: operations}
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
  def tokenize(line, %{stack: stack, current: current, operations: operations}) do
    case line |> String.at(-1) do
      @opening_brace ->
      case stack |> Enum.count do
        0 ->
          if is_nil(current) do
            %{stack: stack, current: line |> new_operation(current), operations: operations}
          else
            if line |> String.contains?(":") do
              %{"type" => type, "name" => name, "arguments" => arguments} =
                %{"type" => "query"} |> Map.merge(@operation_pattern |> Regex.named_captures(line))
              new_current = %{current | name: name |> String.to_atom, arguments: arguments |> tokenize_arguments}
              %{stack: stack |> stack_push([]), current: new_current, operations: operations}
            else
              %{stack: stack |> stack_push([]), current: current, operations: operations}
            end
          end
        _ ->
          {top, remaining} = stack |> stack_pop
          new_top =
            top
            |> stack_push({
              line
              |> String.replace(",", "")
              |> String.replace(@closing_brace, "")
              |> String.replace(@opening_brace, "")
              |> String.trim
              |> String.to_atom,
              %{}
            })
          new_stack = remaining |> stack_push(new_top) |> stack_push([])
          %{stack: new_stack, current: current, operations: operations}
      end

      @closing_brace ->
        case stack |> Enum.count do
          0 ->
            %{stack: [], current: nil, operations: operations}
          1 ->
            new_operations =
              operations
              |> stack_push(%{current | fields: stack |> stack_pop |> elem(0) |> Enum.into(%{})})
            %{stack: [], current: nil, operations: new_operations}
          _ ->
            {top, rest} = stack |> stack_pop
            {new_top, remaining} = rest |> stack_pop
            {parent, others} = new_top |> stack_pop
            new_parent = others |> stack_push({parent |> elem(0), top |> Enum.into(%{})})

            %{stack: remaining |> stack_push(new_parent), current: current, operations: operations}
        end

      _ ->
        {top, remaining} = stack |> stack_pop
        new_top = top |> stack_push({
          line
          |> String.replace(",", "")
          |> String.trim
          |> String.to_atom,
          %{}
        })

        %{stack: remaining |> stack_push(new_top), current: current, operations: operations}
    end
  end

  @doc false
  defp new_field(name, current) do
    current |> Map.update(name, %{}, &(&1))
  end

  @doc false
  defp new_operation(line, current) do
    %{"type" => type, "name" => name, "arguments" => arguments} =
      %{"type" => "query"} |> Map.merge(@operation_pattern |> Regex.named_captures(line))

    parsed = arguments |> tokenize_arguments

    var? = String.contains?(line, "$")

    %Operation{
      type: type |> String.to_atom,
      user_defined_name: name |> String.to_atom,
      arguments: if var? do %{} else parsed end,
      fields: %{},
      variables: if var? do parsed else %{} end
    }
  end

  @doc false
  defp tokenize_arguments(variables) do
    variables
    |> String.replace(@closing_brace, "")
    |> String.replace(@opening_brace, "")
    |> String.replace(@close_argument, "")
    |> String.replace(@open_argument, "")
    |> String.replace(",", "")
    |> String.replace(": ", ":")
    |> String.split(" ")
    |> Enum.reduce(%{}, fn (arg, vars) ->
      [name, value] = arg |> String.split(":")
      vars |> Map.update(name |> String.replace("$", "") |> String.to_atom, value |> String.replace("\"", ""), &(&1))
    end)
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
