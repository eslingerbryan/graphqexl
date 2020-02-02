defmodule Graphqexl.Tokens do
  @keywords %{
    enum: "enum",
    interface: "interface",
    implements: "implements",
    schema: "schema",
    type: "type",
    union: "union",
  }
  def keywords, do: @keywords

  @operation_keywords [:enum, :interface, :schema, :type, :union]

  @tokens %{
    argument: %{
      close: ")",
      open: "(",
    },
    argument_delimiter: ":",
    argument_placeholder_separator: ";",
    assignment: "=",
    custom_scalar_placeholder: "^",
    list: %{
      close: "]",
      open: "[",
    },
    operations: @keywords |> Map.split(@operation_keywords) |> elem(0),
    operation_delimiter: "@",
    patterns: %{
      name: "\[?[_A-Z][_A-Za-z]+!?\]?",
      enum_value: "[_A-Z0-9]+",
      field_name: "[_a-z][_A-Za-z]+",
    },
    required: "!",
  }
  def tokens, do: @tokens
end
