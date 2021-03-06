alias Graphqexl.Query.{
  Operation,
  ResultSet,
  Validator,
}
alias Graphqexl.{
  Schema,
  Tokens,
}
alias Treex.Tree

defmodule Graphqexl.Query do
  @moduledoc """
  GraphQL query, comprised of one or more `t:Graphqexl.Query.Operation.t/0`s.

  Built by calling `parse/1` with either a `t:Graphqexl.Query.gql/0` string
  (see `Graphqexl.Schema.Dsl`) or `t:Graphqexl.Query.json/0`.
  """
  @moduledoc since: "0.1.0"

  @enforce_keys [:operations]
  defstruct [:operations]

  @type gql:: String.t
  @type json:: %{String.t => term}
  @type resolver_fun:: (Map.t, Map.t, Map.t -> term)
  @type tokenizing_map:: %{stack: list, current: Operation.t, operations: list(Operation.t)}

  @type t :: %Graphqexl.Query{operations: list(Operation.t)}

  @doc """
  Execute the given `t:Graphqexl.Query.t/0`

  Returns: `t:Graphqexl.Query.ResultSet.t/0`
  """
  @doc since: "0.1.0"
  @spec execute(t, Schema.t) :: ResultSet.t
  def execute(query, schema) do
    query
    |> validate!(schema)
    |> resolve!(schema)
  end

  @doc """
  Parse the given `t:Graphqexl.Schema.gql/0` string (see `Graphqexl.Schema.Dsl`) into a
  `t:Graphqexl.Query.t/0`

  Returns: `t:Graphqexl.Query.t/0`
  """
  @doc since: "0.1.0"
  @spec parse(gql):: t
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
  Parse the given `t:Graphqexl.Query.json/0` object into a `t:Graphqexl.Query.t/0`

  Returns: `t:Graphqexl.Query.t/0`
  """
  @doc since: "0.1.0"
  @spec parse(json):: t
  def parse(_json) # TODO: convert bare map to %Query{}

  @doc false
  @spec hydrate_arguments(Map.t, Map.t):: Map.t
  defp hydrate_arguments(arguments, variables) do
    arguments
    |> Enum.reduce(%{}, fn ({key, value}, hydrated_args) ->
      val = if is_atom(value) do
        variables |> Map.get(value)
      else
        value
      end
      hydrated_args |> Map.update(key, val, &(&1))
    end)
  end

  @doc false
  @spec insert(ResultSet.t, Operation.t, Schema.t, Map.t):: ResultSet.t
  defp insert(result_set, operation, schema, context) do
    # TODO: pattern match on the whole {:ok, data} / {:error, errors} idea
    data_or_errors =
      operation
      |> invoke!(
           schema.resolvers |> Map.get(operation.name),
           context
         )
    %{
      result_set |
      data: result_set.data |> Map.update(operation.user_defined_name, data_or_errors, &(&1))
    }
  end

  @doc false
  @spec invoke!(Operation.t, resolver_fun, Map.t):: Map.t | list(Map.t)
  defp invoke!(operation, resolver, context) do
    # TODO: probably want to do the error handling here, and return a {:ok, data} or {:error, errors} type of structure
    # TODO: parent context (i.e. where in the current query tree is this coming from)
    # TODO: recursively filter to selected fields
    resolver |> apply([%{}, operation.arguments |> hydrate_arguments(operation.variables), context])
  end

  @doc false
  @spec new_operation(String.t):: Operation.t
  defp new_operation(line) do
    %{"type" => type, "name" => name, "arguments" => arguments} =
      %{"type" => "query"} |> Map.merge(:query_operation |> Tokens.patterns |> Regex.named_captures(line))

    {args, vars} =
      if arguments |> String.at(1) == :variable |> Tokens.get do {nil, arguments} else {arguments, nil} end

    %Operation{
      name: "@TO_BE_SET",
      type: type |> String.to_atom,
      user_defined_name: name |> String.to_atom,
      arguments: args |> tokenize_arguments,
      fields: %{},
      variables: vars |> tokenize_variables
    }
  end

  @doc false
  @spec parse_value(String.t):: boolean | integer | float | String.t
  defp parse_value("false"), do: false
  defp parse_value("true"), do: true
  defp parse_value("null"), do: nil
  defp parse_value(value) do
    numeric? = Regex.match?(~r/"(\d+(\.\d+)?)"/, value)
    string? = Regex.match?(~r/\"(.*)\"/, value)
    cond do
      numeric? -> value |> String.replace(:quote |> Tokens.get, "")
      string? -> value |> String.replace(:quote |> Tokens.get, "")
      true -> raise "Invalid type: expected a string, number, boolean or null, got #{value}"
    end
  end

  @doc false
  @spec postprocess_variables(String.t):: String.t
  defp postprocess_variables(variables) do
    variables
    |> String.replace(:argument |> Tokens.get |> Map.get(:close), "")
    |> String.replace(:argument |> Tokens.get |> Map.get(:open), "")
    |> String.replace(:variable |> Tokens.get, "")
    |> preprocess_line
  end

  @doc false
  @spec preprocess(gql):: list(String.t)
  defp preprocess(gql) do
    gql
    |> pre_preprocess
    |> String.split(:newline |> Tokens.get)
    |> Enum.map(&String.trim/1)
    # This only works _after_ the map/trim above (otherwise the # may not be the first char)
    |> Enum.filter(&(!String.starts_with?(&1, :comment_char |> Tokens.get)))
    |> Enum.map(&(&1 |> String.replace("#{:newline |> Tokens.get}#{:fields |> Tokens.get |> Map.get(:open)}", :fields |> Tokens.get |> Map.get(:open))))
  end

  @doc false
  @spec preprocess_line(String.t):: String.t
  defp preprocess_line(line) do
    line
    |> String.replace(:ignored_delimiter |> Tokens.get, "")
    |> String.replace(:fields |> Tokens.get |> Map.get(:close), "")
    |> String.replace(:fields |> Tokens.get |> Map.get(:open), "")
    |> String.trim
  end

  @doc false
  @spec pre_preprocess(gql):: String.t
  defp pre_preprocess(gql), do: gql |> String.trim

  @doc false
  @spec preprocess_variables(String.t):: String.t
  defp preprocess_variables(variables) do
    variables
    |> String.replace(
         "#{:argument_delimiter |> Tokens.get}#{:space |> Tokens.get}",
         :argument_delimiter |> Tokens.get
       )
  end

  @doc false
  @spec resolve!(t, Schema.t, Map.t):: ResultSet.t
  defp resolve!(query, schema, context \\ %{}) do
    query.operations
    |> Enum.reduce(%ResultSet{}, &(&2 |> insert(&1, schema, context)))
    |> ResultSet.validate!(schema)
    |> ResultSet.filter(query.operations |> List.first |> Map.get(:fields))
  end

  @doc false
  @spec stack_pop(list):: term
  defp stack_pop(stack), do: stack |> List.pop_at(0)

  @doc false
  @spec stack_push(list, term):: list
  defp stack_push(stack, value), do: stack |> List.insert_at(0, value)

  @doc false
  @spec tokenize(String.t, tokenizing_map):: tokenizing_map
  defp tokenize(line, %{stack: stack, current: current, operations: operations}) do
    last_char = line |> String.at(-1)
    cond do
      last_char == :fields |> Tokens.get |> Map.get(:open) ->
        case stack |> Enum.count do
          0 ->
            if is_nil(current) do
              %{stack: stack, current: line |> new_operation, operations: operations}
            else
              if line |> String.contains?(:argument_delimiter |> Tokens.get) do
                %{"name" => name, "arguments" => arguments} =
                  %{"type" => "query"}
                  |> Map.merge(
                       :query_operation
                       |> Tokens.patterns
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

      last_char == :fields |> Tokens.get |> Map.get(:close) ->
        case stack |> Enum.count do
          0 ->
            %{stack: [], current: nil, operations: operations}
          1 ->
            %{
              stack: [],
              current: current,
              operations: operations |> stack_push(%{
                current |
                fields: stack
                        |> stack_pop
                        |> elem(0)
                        |> Enum.into(%{})
                        |> Tree.from_map(current.user_defined_name)
              })
            }
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
  @spec tokenize_arguments(String.t | nil):: Map.t
  defp tokenize_arguments(nil), do: %{}
  defp tokenize_arguments(arguments) do
    arguments
    |> preprocess_variables
    |> String.split(:space |> Tokens.get)
    |> Enum.reduce(%{}, fn (arg, vars) ->
      [name, value] = arg |> String.split(:argument_delimiter |> Tokens.get)
      vars
      |> Map.update(
           name
           |> postprocess_variables
           |> String.to_atom,
           value
           |> postprocess_variables
           |> String.to_atom,
           &(&1)
         )
    end)
  end

  @doc false
  @spec tokenize_variables(String.t | nil):: Map.t
  defp tokenize_variables(nil), do: %{}
  defp tokenize_variables(variables) do
    variables
    |> preprocess_variables
    |> String.split(:space |> Tokens.get)
    |> Enum.reduce(%{}, fn (arg, vars) ->
      [name, value] = arg |> String.split(:argument_delimiter |> Tokens.get)
      vars
      |> Map.update(
           name
           |> postprocess_variables
           |> String.to_atom,
           value
           |> postprocess_variables
           |>  parse_value,
           &(&1)
         )
    end)
  end

  @doc false
  @spec validate!(t, Schema.t):: boolean
  defp validate!(query, schema) do
    true = query.operations |> Enum.all?(&(Validator.valid?(&1, schema)))
    query
  end
end
