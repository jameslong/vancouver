defmodule Vancouver.Tool do
  @moduledoc """
  Behaviour for Mcp tools.
  """
  alias Vancouver.JsonRpc2
  alias Vancouver.Method

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
  @callback run(conn :: Plug.Conn.t(), params :: map()) :: Plug.Conn.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour Vancouver.Tool
      import Vancouver.Tool

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

  def send_text(%Plug.Conn{} = conn, text) when is_binary(text) do
    result = %{
      content: %{
        type: "text",
        text: text
      },
      isError: false
    }

    send_success(conn, result)
  end

  def send_error(%Plug.Conn{} = conn, message) do
    result = %{
      content: %{
        type: "text",
        text: message
      },
      isError: true
    }

    send_success(conn, result)
  end

  def send_success(%Plug.Conn{} = conn, result) do
    request_id = conn.body_params["id"]
    response = JsonRpc2.success_response(request_id, result)

    Method.send_json(conn, response)
  end
end
