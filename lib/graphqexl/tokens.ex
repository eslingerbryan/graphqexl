defmodule Graphqexl.Tokens do
  defmodule Regex do
    def escape(char), do: "\\#{char}"
  end

  @identifiers %{
    enum_value: "[_A-Z0-9]+",
    field_name: "[_a-z][_A-Za-z0-9]+",
    name: "[_A-Z][_A-Za-z]+",
    type_value: "\[?[_A-Z][_A-Za-z]+!?\]?",
  }
  def identifiers, do: @identifiers

  @keywords %{
    enum: "enum",
    interface: "interface",
    implements: "implements",
    mutations: "mutations",
    queries: "queries",
    schema: "schema",
    subscriptions: "subscriptions",
    type: "type",
    union: "union",
  }
  def keywords, do: @keywords

  @operation_keywords [:enum, :interface, :schema, :type, :union]
  @reserved_types [:mutation, :query, :subscription]

  @tokens %{
    argument: %{
      close: ")",
      open: "(",
    },
    argument_delimiter: ":",
    argument_placeholder_separator: ";",
    assignment: "=",
    comment_char: "#",
    custom_scalar_placeholder: "^",
    fields: %{
      close: "}",
      open: "{",
    },
    ignored_delimiter: ",",
    ignored_whitespace: "\t",
    list: %{
      close: "]",
      open: "[",
    },
    newline: "\n",
    quote: "\"",
    operations: @keywords |> Map.split(@operation_keywords) |> elem(0),
    operation_delimiter: "@",
    required: "!",
    reserved_types: @keywords |> Map.split(@reserved_types) |> elem(0),
    space: "\s",
    union_type_delimiter: "|",
    variable: "$",
  }
  def tokens, do: @tokens

  @argument_pattern """
  (#{@identifiers.field_name})#{@tokens.argument_delimiter}\s*?(#{@identifiers.type_value})
  """
  @query_argument_pattern "?<arguments>\(?\(\$?.*\)"
  @name_pattern "?<name>#{@identifiers.field_name}"
  @type_pattern "?<type>(query|mutation|subscription)"
  @patterns %{
    argument: ~r/#{@argument_pattern}\n/,
    comment: ~r/#{@tokens.comment_char}.*/,
    custom_scalar: ~r/(#{@keywords.type}.*\s?)#{@tokens.assignment}\s?/,
    field_name: ~r/(?<name>#{@identifiers.field_name})/,
    implements: ~r/\s#{@keywords.implements}\s(#{@identifiers.type_value})\s/,
    operation: ~r/(?<name>.*)\((?<args>.*)?\):(?<return>.*)/,
    query_operation: ~r/(#{@type_pattern})?\s?(#{@name_pattern})(?<arguments>\(?\(\$?.*\))?\s\{/,
    significant_whitespace: ~r/[#{@tokens.newline}|#{@tokens.space}]+/,
    trailing_space: ~r/#{@tokens.space}#{@tokens.newline}/,
    union: ~r/(#{@keywords.union}.*\s?)#{@tokens.assignment}\s?/,
    union_type_separator: ~r/\s?#{@tokens.union_type_delimiter |> Regex.escape}\s?/,
    variable_value: ~r/\"[\w|_]+\"|\d+|true|false|null/
  }
  def patterns, do: @patterns
end
