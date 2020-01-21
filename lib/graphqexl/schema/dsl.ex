alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Enum,
  Interface,
  Mutation,
  Query,
  Subscription,
  Type,
  Union,
}

defmodule Graphqexl.Schema.Dsl do
  @moduledoc """
  Domain-Specific Language for expressing and parsing a GQL string as a %Graphqexl.Schema{}
  """

  @patterns %{
    name: "[_A-Z][_A-Za-z]+",
    enum_value: "[_A-Z0-9]+",
    field_name: "[_a-z][_A-Za-z]",
  }

  @doc """
  Prepares the graphql schema dsl string for parsing

  Returns %Graphqexl.Schema{}

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

  Returns %Graphqexl.Schema{}

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def enum(schema, name, values) do
    schema |> Schema.register(%Enum{name: name, values: values})
  end

  @doc """
  Creates a new schema from the given spec

  Returns %Graphqexl.Schema{}

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def schema(schema, fields: fields) do

  end

  @doc """
  Creates a new query from the given spec

  Returns %Graphqexl.Schema{}

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def query(schema, fields: fields) do
    schema |> Schema.register(%Query{fields: fields})
  end

  @doc """
  Creates a new mutation from the given spec

  Returns %Graphqexl.Schema{}

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def mutation(schema, fields: fields) do
    schema |> Schema.register(%Mutation{fields: fields})
  end

  @doc """
  Creates a new subscription from the given spec

  Returns %Graphqexl.Schema{}

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def subscription(schema, fields: fields) do
    schema |> Schema.register(%Subscription{fields: fields})
  end

  @doc """
  Creates a new type from the given spec

  Returns %Graphqexl.Schema{}

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def type(schema, name, implements: implements, fields: fields) do
    schema |> Schema.register(%Type{name: name, implements: implements, fields: fields})
  end

  @doc """
  Creates a new union from the given spec

  Returns %Graphqexl.Schema{}

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def union(schema, name, type1, type2) do
    schema |> Schema.register(%Union{name: name, type1: type1, type2: type2})
  end

  @doc """
  Creates a new interface from the given spec

  Returns %Graphqexl.Schema{}

  TODO: docstring examples
  """
  @doc since: "0.1.0"
  def interface(schema, name, fields: fields) do
    schema |> Schema.register(%Interface{name: name, fields: fields})
  end

  @doc false
  defp compact(gql) do
    gql
    |> regex_replace(~r/\n+/, "\n")
    |> regex_replace(~r/,+/, ",")
    |> regex_replace(~r/(:|,)\s+/, "\\g{1}\s")
    |> regex_replace(~r/{\s+/, "{")
    |> regex_replace(~r/\[\s+/, "[")
    |> String.replace(" ,", ",")
    |> String.trim
  end

  @doc false
  defp regex_replace(string, pattern, replacement), do: Regex.replace(pattern, string, replacement)

  @doc false
  defp replace(gql) do
    gql
    |> String.replace(" = ", ", ")
    |> String.replace("{\n", ", fields: %{")
    |> String.replace(", }", "}")
    |> String.replace(", ]", "]")
  end

  @doc false
  defp strip(gql) do
    gql
    |> (& Regex.replace(~r/#.*/, &1, "")).()
    |> String.replace(",", "")
  end

  @doc false
  defp transform(gql) do
    gql
    |> regex_replace(~r/enum (#{@patterns.name}) {\n/, "enum \\g{1}, [")
    |> regex_replace(~r/(#{@patterns.enum_value})\n/, ":\\g{1}, ")
    |> regex_replace(~r/(enum .*)}/, "\\g{1}]")
    |> regex_replace(~r/(#{@patterns.field_name}:\s*#{@patterns.name})\n/, "\\g{1}, ")
    |> regex_replace(~r/\simplements\s(#{@patterns.name})\s/, ", implements: \\g{1}")
    |> regex_replace(~r/(union #{@patterns.name}) (.*) \| (.*)/, "\\g{1} \\g{2}, \\g{3}")
  end
end
