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

defmodule Graphqexl.Schema.Dsl do
  import Graphqexl.Tokens

  @moduledoc """
  Domain-Specific Language for expressing and parsing a GQL string as a `t:Graphqexl.Schema.t/0`
  """

  @doc """
  Prepares the graphql schema dsl string for parsing

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def preprocess(gql) do
    gql
    |> strip
    |> transform
    |> replace
    |> compact
  end

  @doc """
  Creates a new enum from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def enum(schema, name, values) do
    schema |> Schema.register(%TEnum{name: name, values: values |> parse_enum_values})
  end

  @doc false
  defp parse_enum_values(values) do
    values |> Enum.map(&String.to_atom/1)
  end

  @doc """
  Creates a new query from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def query(schema, spec) do
    %{"args" => args, "name" => name, "return" => return} =
      Regex.named_captures(~r/(?<name>.*)\((?<args>.*)?\):(?<return>.*)/, spec)

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
  Creates a new mutation from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def mutation(schema, spec) do
    %{"args" => args, "name" => name, "return" => return} =
      Regex.named_captures(~r/(?<name>.*)\((?<args>.*)?\):(?<return>.*)/, spec)
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
  Creates a new subscription from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def subscription(schema, spec) do
    %{"args" => args, "name" => name, "return" => return} =
      Regex.named_captures(~r/(?<name>.*)\((?<args>.*)?\):(?<return>.*)/, spec)
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

  def type(schema, name, implements) do
    schema
    |> Schema.register(
         %Type{
           name: name,
           implements: %Ref{type: implements |> String.to_atom}
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

  @doc """
  Creates a new interface from the given spec

  Returns `t:Graphqexl.Schema.t/0`

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def interface(schema, name, fields) do
    schema
    |> Schema.register(
         %Interface{
           name: name,
           fields: fields |> parse_fields
         }
       )
  end

  @doc false
  defp compact(gql) do
    gql
    |> String.replace("{", "")
    |> String.replace("}", "")
    |> regex_replace(~r/\s+/, " ")
    |> regex_replace(~r/\t+/, " ")
    |> regex_replace(~r/\n+/, "\n")
    |> String.replace("@", "\n")
    |> String.replace(" \n", "\n")
    |> String.trim
  end

  @doc false
  defp regex_replace(string, pattern, replacement), do: Regex.replace(pattern, string, replacement)

  @doc false
  defp replace(gql) do
    gql
    |> regex_replace(~r/\s?\|\s?/, " ")
    |> String.replace(",", "")
    |> String.replace(": ", ":")
  end

  @doc false
  defp strip(gql) do
    gql |> regex_replace(~r/#.*/, "")
  end

  @doc false
  defp transform(gql) do
    gql
    |> regex_replace(~r/(#{keywords.type}.*\s?)#{tokens.assignment}\s?/, "\\g{1} #{tokens.custom_scalar_placeholder}")
    |> regex_replace(~r/(#{keywords.union}.*\s?)#{tokens.assignment}\s?/, "\\g{1} ")
    |> regex_replace(~r/(#{tokens.patterns.field_name})#{tokens.argument_delimiter}\s*?(#{tokens.patterns.name})\n/, "\\g{1}:\\g{2}")
    |> regex_replace(~r/\s#{keywords.implements}\s(#{tokens.patterns.name})\s/, " \\g{1}")
    |> regex_replace(~r/(#{tokens.operations |> regex_unionize})/, "#{tokens.operation_delimiter}\\g{1}")
  end

  @doc false
  defp regex_unionize(patterns) do
    patterns
    |> Map.values
    |> Enum.join("|")
  end

  @doc false
  defp parse_fields(fields) do
    fields
    |> Enum.map(&(String.split(&1, tokens.argument_delimiter)))
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
  defp maybe_list(ref) do
    if ref.type |> is_list? do ref |> list_field_value else ref end
  end

  @doc false
  defp maybe_required(ref) do
    if ref.type |> is_required? do ref |> required_field_value else ref end
  end

  @doc false
  defp is_required?(component = %{type: _}) do
    component.type |> is_required?
  end

  @doc false
  defp is_required?(value) when is_atom(value), do: is_required?(value |> Atom.to_string)

  @doc false
  defp is_required?(value) do
    value |> String.contains?(tokens.required)
  end

  @doc false
  defp is_list?(component = %{type: _}) do
    component.type |> is_list?
  end

  @doc false
  defp is_list?(value) when is_atom(value), do: is_list?(value |> Atom.to_string)

  @doc false
  defp is_list?(value) do
    value |> String.contains?(tokens.list.open)
  end

  @doc false
  defp required_field_value(component = %Ref{}) do
    %Ref{
      type: %Required{type: tokens.required |> atomize_field_value(component.type)}
    }
  end

  @doc false
  defp list_field_value(component = %Ref{}) do
    [%Ref{type: [tokens.list.open, tokens.list.close] |> atomize_field_value(component.type)}]
  end

  @doc false
  defp atomize_field_value(replace, value) when is_list(replace) do
    replace |> Enum.reduce(value, &atomize_field_value/2)
  end

  @doc false
  defp atomize_field_value(replace, value)
       when is_atom(value), do: atomize_field_value(replace, value |> Atom.to_string)

  @doc false
  defp atomize_field_value(replace, value) when is_binary(value) do
    value |> String.replace(replace, "") |> String.to_atom
  end

  @doc false
  defp parse_query_args(args) do
    args
    |> String.split(tokens.argument_placeholder_separator)
    |> Enum.map(&(String.split(&1, tokens.argument_delimiter)))
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
end
