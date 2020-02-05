alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Argument,
  Field,
  Interface,
  Mutation,
  Query,
  Ref,
  Required,
  Subscription,
  TEnum,
  Type,
  Union,
}
alias Graphqexl.Tokens
alias Treex.Tree

defmodule Graphqexl.Schema.Dsl do
  @moduledoc """
  Domain-Specific Language for expressing and parsing a GQL string as a `t:Graphqexl.Schema.t/0`
  """

  @type gql :: String.t

  @doc """
  Creates a new enum from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  @spec enum(Schema.t, atom, String.t):: Schema.t
  def enum(schema, name, values),
      do: schema |> Schema.register(%TEnum{name: name, values: values |> parse_enum_values})

  @doc """
  Creates a new interface from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  @spec interface(Schema.t, atom, Tree.t):: Schema.t
  def interface(schema, name, fields) do
    schema
    |> Schema.register(
         %Interface{
           name: name,
           fields: fields |> parse_fields
         }
       )
  end

  @doc """
  Creates a new mutation from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  @spec mutation(Schema.t, String.t):: Schema.t
  def mutation(schema, spec) do
    %{"args" => args, "name" => name, "return" => return} =
      Tokens.patterns.operation |> Regex.named_captures(spec)
    schema
    |> Schema.register(
         %Mutation{
           arguments: args |> parse_query_args,
           name: name |> String.to_atom,
           return: %Ref{type: return |> String.to_atom}
         }
       )
  end

  @doc """
  Prepares the graphql schema dsl string for parsing

  Returns `t:String.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  @spec preprocess(gql):: String.t
  def preprocess(gql) do
    gql
    |> strip
    |> transform
    |> replace
    |> compact
  end

  @doc """
  Creates a new query from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  @spec query(Schema.t, String.t):: Schema.t
  def query(schema, spec) do
    %{"args" => args, "name" => name, "return" => return} =
      Tokens.patterns.operation |> Regex.named_captures(spec)

    schema
    |> Schema.register(
         %Query{
           arguments: args |> parse_query_args,
           name: name |> String.to_atom,
           return: return |> parse_field_values
         }
       )
  end

  @doc """
  Creates a new subscription from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  @spec subscription(Schema.t, String.t):: Schema.t
  def subscription(schema, spec) do
    %{"args" => args, "name" => name, "return" => return} =
      Tokens.patterns.operation |> Regex.named_captures(spec)
    schema
    |> Schema.register(
         %Subscription{
           arguments: args |> parse_query_args,
           name: name |> String.to_atom,
           return: %Ref{type: return |> String.to_atom}
         }
       )
  end

  @doc """
  Creates a new type from the given spec

  Returns %Graphqexl.Schema{}

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  @spec type(Schema.t, atom, String.t):: Schema.t
  @spec type(Schema.t, atom, String.t | nil, Tree.t):: Schema.t
  def type(schema, name, implements) do
    schema
    |> Schema.register(
         %Type{
           name: name,
           implements: %Ref{type: implements |> String.to_atom}
         }
       )
  end
  def type(schema, name, nil, fields) do
    schema
    |> Schema.register(
         %Type{
           name: name,
           implements: nil,
           fields: fields |> parse_fields
         }
       )
  end
  def type(schema, name, implements, fields) do
    schema |>
      Schema.register(
        %Type{
          name: name,
          implements: %Ref{type: implements |> String.to_atom},
          fields: fields |> parse_fields
        }
      )
  end

  @doc """
  Creates a new union from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  @spec union(Schema.t, atom, String.t, String.t):: Schema.t
  def union(schema, name, type1, type2) do
    schema
    |> Schema.register(
         %Union{
           name: name,
           type1: %Ref{type: type1 |> String.to_atom},
           type2: %Ref{type: type2 |> String.to_atom}
         }
       )
  end

  @doc false
  defp atomize_field_value(replace, value) when is_list(replace),
       do: replace |> Enum.reduce(value, &atomize_field_value/2)

  @doc false
  defp atomize_field_value(replace, value) when is_atom(value),
       do: replace |> atomize_field_value(value |> Atom.to_string)

  @doc false
  defp atomize_field_value(replace, value) when is_binary(value) do
    value
    |> String.replace(replace, "")
    |> String.to_atom
  end

  @doc false
  defp compact(gql) do
    gql
    |> String.replace(Tokens.get.fields.open, "")
    |> String.replace(Tokens.get.fields.close, "")
    |> String.replace(Tokens.get.ignored_whitespace, Tokens.get.space)
    |> regex_replace(Tokens.patterns.significant_whitespace, Tokens.get.space)
    |> String.replace(Tokens.get.operation_delimiter, Tokens.get.newline)
    |> String.replace(Tokens.patterns.trailing_space, Tokens.get.newline)
    |> String.replace("#{Tokens.get.argument_delimiter}#{Tokens.get.space}", Tokens.get.argument_delimiter)
    |> String.trim
  end

  @doc false
  defp list_field_value(component = %Ref{}) do
    [%Ref{type: [Tokens.get.list.open, Tokens.get.list.close] |> atomize_field_value(component.type)}]
  end

  @doc false
  defp list?(component = %{type: _}), do: component.type |> list?

  @doc false
  defp list?(value) when is_atom(value), do: list?(value |> Atom.to_string)

  @doc false
  defp list?(value), do: value |> String.contains?(Tokens.get.list.open)

  @doc false
  defp maybe_list(ref) do
    if ref.type |> list? do ref |> list_field_value else ref end
  end

  @doc false
  defp maybe_required(ref) do
    if ref.type |> required? do ref |> required_field_value else ref end
  end

  @doc false
  defp parse_enum_values(values) do
    values |> Enum.map(&String.to_atom/1)
  end

  @doc false
  defp parse_fields(fields) do
    fields
    |> Enum.map(&(String.split(&1, Tokens.get.argument_delimiter)))
    |> Enum.map(&(
      {
        &1 |> List.first |> String.to_atom,
        %Field{
          name: &1 |> List.first |> String.to_atom,
          value: &1 |> List.last |> parse_field_values
        }
      }))
    |> Enum.into(%{})
  end

  @doc false
  defp parse_field_values(value) do
    %Ref{type: value |> String.to_atom}
    |> maybe_required
    |> maybe_list
  end

  @doc false
  defp parse_query_args(args) do
    args
    |> String.split(Tokens.get.argument_placeholder_separator)
    |> Enum.map(&(String.split(&1, Tokens.get.argument_delimiter)))
    |> Enum.map(&(
      {
        &1 |> List.first |> String.to_atom,
        %Argument{
          name: &1 |> List.first |> String.to_atom,
          type: &1 |> List.last |> parse_field_values
        }
      }
      ))
    |> Enum.into(%{})
  end

  @doc false
  defp regex_unionize(patterns) do
    patterns
    |> Map.values
    |> Enum.join("|")
  end

  @doc false
  defp replace(gql) do
    gql
    |> regex_replace(Tokens.patterns.union_type_separator, Tokens.get.space)
    |> String.replace(Tokens.get.ignored_delimiter, "")
  end

  @doc false
  defp required_field_value(component = %Ref{}) do
    %Ref{
      type: %Required{type: Tokens.get.required |> atomize_field_value(component.type)}
    }
  end

  @doc false
  defp required?(component = %{type: _}), do: component.type |> required?

  @doc false
  defp required?(value) when is_atom(value), do: value |> Atom.to_string |> required?

  @doc false
  defp required?(value), do: value |> String.contains?(Tokens.get.required)

  @doc false
  defp regex_replace(string, pattern, replacement),
       do: pattern |> Regex.replace(string, replacement)

  @doc false
  defp strip(gql), do: gql |> regex_replace(Tokens.patterns.comment, "")

  @doc false
  defp transform(gql) do
    gql
    |> regex_replace(Tokens.patterns.custom_scalar, "\\g{1} #{Tokens.get.custom_scalar_placeholder}")
    |> regex_replace(Tokens.patterns.union, "\\g{1}#{Tokens.get.space}")
    |> regex_replace(Tokens.patterns.argument, "\\g{1}#{Tokens.get.argument_delimiter}\\g{2}")
    |> regex_replace(Tokens.patterns.implements, "#{Tokens.get.space}\\g{1}")
    |> regex_replace(
         ~r/(#{Tokens.get.operations |> regex_unionize})/,
         "#{Tokens.get.operation_delimiter}\\g{1}"
       )
  end
end
