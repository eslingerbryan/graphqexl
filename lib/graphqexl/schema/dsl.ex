alias Graphqexl.Schema
alias Graphqexl.Schema.{
  Argument,
  Enum,
  Field,
  Interface,
  Mutation,
  Query,
  Subscription,
  Type,
  Union,
}

defmodule Graphqexl.Schema.Dsl do
  @doc "Prepares the graphql schema dsl string for parsing"

  @patterns %{
    name: "[_A-Z][_A-Za-z]+",
    enum_value: "[_A-Z0-9]+",
    field_name: "[_a-z][_A-Za-z]",
  }

  def preprocess(gql) do
    gql
    |> strip
    |> transform
    |> replace
    |> compact
  end

  def enum(schema, name, values) do
    schema |> Schema.register(%Enum{name: name, values: values})
  end

  def schema(schema, fields: %{}) do

  end

  def query(schema, fields: %{}) do
    schema |> Schema.register(%Query{fields: fields})
  end

  def mutation(schema, fields: %{}) do
    schema |> Schema.register(%Mutation{fields: fields})
  end

  def subscription(schema, fields: %{}) do
    schema |> Schema.register(%Subscription{fields: fields})
  end

  def type(schema, name, implements: nil, fields: %{}) do
    schema |> Schema.register(%Type{name: name, implements: implements, fields: fields})
  end

  def union(schema, name, type1, type2) do
    schema |> Schema.register(%Union{name: name, type1: type1, type2: type2})
  end

  def interface(schema, name, fields: %{}) do
    schema |> Schema.register(%Interface{name: name, fields: fields})
  end

  defp compact(gql) do
    gql
    |> (& Regex.replace(~r/\n+/, &1, "\n")).()
    |> (& Regex.replace(~r/,+/, &1, ",")).()
    |> (& Regex.replace(~r/(:|,)\s+/, &1, "\\g{1}\s")).()
    |> (& Regex.replace(~r/{\s+/, &1, "{")).()
    |> (& Regex.replace(~r/\[\s+/, &1, "[")).()
    |> String.replace(" ,", ",")
    |> String.trim
  end

  defp replace(gql) do
    gql
    |> String.replace(" = ", ", ")
    |> String.replace("{\n", ", fields: %{")
    |> String.replace(", }", "}")
    |> String.replace(", ]", "]")
  end

  defp strip(gql) do
    gql
    |> (& Regex.replace(~r/#.*/, &1, "")).()
    |> String.replace(",", "")
  end

  defp transform(gql) do
    gql
    |> (& Regex.replace(~r/enum (#{@patterns.name}) {\n/, &1, "enum \\g{1}, [")).()
    |> (& Regex.replace(~r/(#{@patterns.enum_value})\n/, &1, ":\\g{1}, ")).()
    |> (& Regex.replace(~r/(enum .*)}/, &1, "\\g{1}]")).()
    |> (& Regex.replace(~r/(#{@patterns.field_name}:\s*#{@patterns.name})\n/, &1, "\\g{1}, ")).()
    |> (& Regex.replace(~r/\simplements\s(#{@patterns.name})\s/, &1, ", implements: \\g{1}")).()
    |> (& Regex.replace(~r/(union #{@patterns.name}) (.*) \| (.*)/, &1, "\\g{1} \\g{2}, \\g{3}")).()
  end
end
