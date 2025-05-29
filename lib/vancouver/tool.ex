defmodule Vancouver.Tool do
  @moduledoc """
  Behaviour for Mcp tools.
  """

  @doc """
  The tool's name identifier (must be a string).
  """
  @callback name() :: String.t()

  @doc """
  Human-readable description of what the tool does (must be a string).
  """
  @callback description() :: String.t()

  @doc """
  JSON Schema defining the tool's input parameters (must be a map).
  """
  @callback input_schema() :: map()

  @doc """
  Execute the tool with the given parameters.

  Should return {:ok, result} on success or {:error, message} on failure.
  """
  @callback run(params :: map()) :: {:ok, any()} | {:error, String.t()}

  defmacro __using__(_opts) do
    quote do
      @behaviour Vancouver.Tool

      def definition do
        %{
          "name" => name(),
          "description" => description(),
          "inputSchema" => input_schema()
        }
      end

      def validate_arguments(arguments) do
        Vancouver.JsonRpc2.validate_schema(input_schema(), arguments)
      end
    end
  end
end
