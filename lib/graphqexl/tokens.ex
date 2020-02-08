defmodule Graphqexl.Tokens do
  @moduledoc """
  Mostly a databag module containing keywords, tokens and regex patterns related to the GraphQL
  spec. Also contains functions for fetching them by key.
  """
  @moduledoc since: "0.1.0"

  # TODO: Make the structure here more closely represent the definitions exactly as in the spec:
  # In particular, the input type handling. This will probably make the DSL much cleaner.
  # See if we can shake out a consistent interface for parsing the components, maybe without the
  # need to collapse things into single lines.
  # https://spec.graphql.org/June2018/#TypeDefinition

  @built_in_types %{
    Boolean: "Boolean",
    Float: "Float",
    Id: "Id",
    Integer: "Integer",
    List: "List",
    Object: "Object",
    String: "String",
  }
  @identifiers %{
    enum_value: "[_A-Z0-9]+",
    field_name: "[_a-z][_A-Za-z0-9]+",
    name: "[_A-Z][_A-Za-z]+",
    type_value: "\[?[_A-Z][_A-Za-z]+!?\]?",
  }
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
  @operation_keywords [:enum, :interface, :schema, :type, :union]
  @reserved_types [:mutation, :query, :subscription]

  @scalar_types @built_in_types
                |> Map.split([:Boolean, :Float, :Id, :Integer, :String])
                |> elem(0)
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
    types: %{scalar: @scalar_types |> Map.values},
    space: "\s",
    union_type_delimiter: "|",
    variable: "$",
  }

  defmodule Regex do
    @moduledoc"""
    Utility module with helper functions for working with `t:Regex.t/0`'s.
    """
    @moduledoc since: "0.1.0"

    @doc """
    Escapes the given character or sequence.

    Returns: `t:String.t/0`
    """
    @doc since: "0.1.0"
    @spec escape(String.t):: String.t
    def escape(char), do: "\\#{char}"
  end

  @doc """
  Retrieve a token by key

  Returns: `t:String.t/0` | Map.t
  """
  @doc since: "0.1.0"
  @spec get(atom):: String.t | Map.t
  def get(key), do: @tokens |> Map.get(key)

  @doc """
  Retrieve an identifier token by key

  Returns: `t:String.t/0`
  """
  @doc since: "0.1.0"
  @spec identifiers(atom):: String.t
  def identifiers(key), do: @identifiers |> Map.get(key)

  @doc """
  Retrieve a keyword token by key

  Returns: `t:String.t/0`
  """
  @doc since: "0.1.0"
  @spec keywords(atom):: String.t
  def keywords(key), do: @keywords |> Map.get(key)

  @argument_pattern """
  (#{@identifiers.field_name})#{@tokens.argument_delimiter}\s*?(#{@identifiers.type_value})
  """
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
  @doc """
  Retrieve a token pattern by key

  Returns: `t:Regex.t/0`
  """
  @doc since: "0.1.0"
  @spec patterns(atom):: Regex.t
  def patterns(key), do: @patterns |> Map.get(key)
end
