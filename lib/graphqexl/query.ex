alias Graphqexl.Query.{
  Operation,
  ResultSet,
  Validator,
}
alias Graphqexl.Schema

defmodule Graphqexl.Query do
  import Graphqexl.Tokens

  @moduledoc """
  GraphQL query, comprised of one or more `t:Graphqexl.Query.Operation.t/0`s.

  Built by calling `parse/1` with either a `t:Graphqexl.Query.gql/0` string
  (see `Graphqexl.Schema.Dsl`) or `t:Graphqexl.Query.json/0`.
  """

  @type gql :: String.t
  @type json :: Map.t
  @type t :: %Graphqexl.Query{operations: [Operation.t]}

  defstruct operations: []

  @doc """
  Execute the given `t:Graphqexl.Query.t/0`

  Returns: `t:Graphqexl.Query.ResultSet.t/0`
  """
  @doc since: "0.1.0"
  @spec execute(Graphqexl.Query.t, Schema.t) :: ResultSet.t
  def execute(query, schema) do
    query
    |> validate!(schema)
    |> resolve!(schema)
  end

  @doc """
  Parse the given gql string (see `Graphqexl.Schema.Dsl`) into a `t:Graphqexl.Query.t/0`

  Returns: `t:Graphqexl.Query.t/0`
  """
  @doc since: "0.1.0"
  @spec parse(gql) :: Query.t
  def parse(gql) when is_binary(gql) do
    %Graphqexl.Query{
      operations:
        gql
        |> preprocess
        |> Enum.reduce(%{stack: [], current: nil, operations: []}, &tokenize/2)
        |> Map.get(:operations)
    }
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
  defp new_operation(line) do
    %{"type" => type, "name" => name, "arguments" => arguments} =
      %{"type" => "query"} |> Map.merge(patterns.query_operation |> Regex.named_captures(line))

    {args, vars} =
      if ~r/\$#{identifiers.field_name}:\s?(\"[\w|_]+\"|\d+|true|false|null)/ |> Regex.match?(line) do
        {nil, arguments}
      else
        {arguments, nil}
      end

    %Operation{
      type: type |> String.to_atom,
      user_defined_name: name |> String.to_atom,
      arguments: args |> tokenize_arguments,
      fields: %{},
      variables: vars |> tokenize_variables
    }
  end

  @doc false
  defp parse_value("false"), do: false
  defp parse_value("true"), do: true
  defp parse_value("null"), do: nil
  defp parse_value(value) do
    numeric? = Regex.match?(~r/"(\d+(\.\d+)?)"/, value)
    string? = Regex.match?(~r/\"(.*)\"/, value)
    cond do
      numeric? -> value |> String.replace(tokens.quote, "")
      string? -> value |> String.replace(tokens.quote, "")
      true -> raise "Invalid type: expected a string, number, boolean or null, got #{value}"
    end
  end

  @doc false
  defp postprocess_variables(variables) do
    variables
    |> String.replace(tokens.argument.close, "")
    |> String.replace(tokens.argument.open, "")
    |> String.replace(tokens.variable, "")
    |> preprocess_line
  end

  @doc false
  defp preprocess(gql) do
    gql
    |> pre_preprocess
    |> String.split(tokens.newline)
    |> Enum.map(&String.trim/1)
    # This only works _after_ the map/trim above (otherwise the # may not be the first char)
    |> Enum.filter(&(!String.starts_with?(&1, tokens.comment_char)))
    |> Enum.map(&(String.replace(&1, "#{tokens.newline}#{tokens.fields.open}", tokens.fields.open)))
  end

  @doc false
  defp preprocess_line(line) do
    line
    |> String.replace(tokens.ignored_delimiter, "")
    |> String.replace(tokens.fields.close, "")
    |> String.replace(tokens.fields.open, "")
    |> String.trim
  end

  @doc false
  defp pre_preprocess(gql) do
    gql |> String.trim
  end

  @doc false
  defp preprocess_variables(variables) do
    variables
    |> String.replace("#{tokens.argument_delimiter}#{tokens.space}", tokens.argument_delimiter)
  end

  @doc false
  defp resolve!(query, schema) do
    data = %{}
#      query.operations
#      |> Enum.reduce(%{}, fn (operation) ->
#        schema.resolvers |> Map.get(operation.name).(
#          %{},
#          query.arguments,
#          schema.context.(query, %{})
#        )
#      end)
    # TODO: intersect result with query.fields
    %ResultSet{data: data, errors: %{}}
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
  defp tokenize(line, %{stack: stack, current: current, operations: operations}) do
    last_char = line |> String.at(-1)
    cond do
      last_char == tokens.fields.open ->
        case stack |> Enum.count do
          0 ->
            if is_nil(current) do
              %{stack: stack, current: line |> new_operation, operations: operations}
            else
              if line |> String.contains?(tokens.argument_delimiter) do
                %{"name" => name, "arguments" => arguments} =
                  %{"type" => "query"}
                  |> Map.merge(
                       patterns.query_operation
                       |> Regex.named_captures(line)
                     )
                new_current = %{
                  current | name: name |> String.to_atom,
                  arguments: arguments |> tokenize_arguments
                }
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
                line |> preprocess_line |> String.to_atom,
                %{}
              })
            new_stack = remaining |> stack_push(new_top) |> stack_push([])
            %{stack: new_stack, current: current, operations: operations}
        end

      last_char == tokens.fields.close ->
        case stack |> Enum.count do
          0 ->
            %{stack: [], current: nil, operations: operations}
          1 ->
            new_operations =
              operations
              |> stack_push(%{current | fields: stack |> stack_pop |> elem(0) |> Enum.into(%{})})
            %{stack: [], current: current, operations: new_operations}
          _ ->
            {top, rest} = stack |> stack_pop
            {new_top, remaining} = rest |> stack_pop
            {parent, others} = new_top |> stack_pop
            new_parent = others |> stack_push({parent |> elem(0), top |> Enum.into(%{})})

            %{stack: remaining |> stack_push(new_parent), current: current, operations: operations}
        end

      true ->
        {top, remaining} = stack |> stack_pop
        new_top = top |> stack_push({line |> preprocess_line |> String.to_atom, %{}})

        %{stack: remaining |> stack_push(new_top), current: current, operations: operations}
    end
  end

  @doc false
  defp tokenize_arguments(nil), do: %{}
  defp tokenize_arguments(arguments) do
    arguments
    |> preprocess_variables
    |> String.split(tokens.space)
    |> Enum.reduce(%{}, fn (arg, vars) ->
      [name, value] = arg |> String.split(tokens.argument_delimiter)
      vars
      |> Map.update(
           name
           |> postprocess_variables
           |> String.to_atom,
           value
           |> postprocess_variables
           |> String.to_atom,
           &Function.identity/1
         )
    end)
  end

  @doc false
  defp tokenize_variables(nil), do: %{}
  defp tokenize_variables(variables) do
    variables
    |> preprocess_variables
    |> String.split(tokens.space)
    |> Enum.reduce(%{}, fn (arg, vars) ->
      [name, value] = arg |> String.split(tokens.argument_delimiter)
      vars
      |> Map.update(
           name
           |> postprocess_variables
           |> String.to_atom,
           value
           |> postprocess_variables
           |>  parse_value,
           &Function.identity/1
         )
    end)
  end

  @doc false
  defp validate!(query, schema) do
    true = query.operations |> Enum.all?(&(Validator.valid?(&1, schema)))
  end
end
