defmodule Vancouver.Tool do
  @moduledoc """
  Tools enable LLMs to perform actions.

  You can implement a tool as follows:

      defmodule MyApp.Tools.CalculateSum do
        use Vancouver.Tool

        def name, do: "calculate_sum"
        def description, do: "Add two numbers together"

        def input_schema do
          %{
            "type" => "object",
            "properties" => %{
              "a" => %{"type" => "number"},
              "b" => %{"type" => "number"}
            },
            "required" => ["a", "b"]
          }
        end

        def run(conn, %{"a" => a, "b" => b}) do
          send_text(conn, "\#{a + b}")
        end
      end

  The input schema must be a valid [JSON Schema](https://json-schema.org) object.

  ## Sending responses

  Tools provide helper functions to send valid MCP responses:

  - `send_json/2` - sends a JSON response
  - `send_text/2` - sends a text response
  - `send_error/2` - sends an error response
  """

  alias Vancouver.JsonRpc2
  alias Vancouver.Method

  @doc """
  Unique identifier for the tool.
  """
  @callback name() :: String.t()

  @doc """
  Human readable description of what the tool does.
  """
  @callback description() :: String.t()

  @doc """
  JSON Schema defining the tool's input parameters.
  """
  @callback input_schema() :: map()

  @doc """
  Execute the tool with the given parameters.
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

  @doc """
  Sends an error response.

  ## Examples

      iex> send_error(conn, "an error occurred")

  """
  @spec send_error(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def send_error(%Plug.Conn{} = conn, message) do
    result = %{
      content: [
        %{
          type: "text",
          text: message
        }
      ],
      isError: true
    }

    send_success(conn, result)
  end

  @doc """
  Sends JSON response.

  ## Examples

      iex> send_json(conn, %{id: 123})

  """
  @spec send_json(Plug.Conn.t(), term()) :: Plug.Conn.t()
  def send_json(%Plug.Conn{} = conn, data), do: send_text(conn, JSON.encode!(data))

  @doc """
  Sends text response.

  ## Examples

      iex> send_text(conn, "hello")

  """
  @spec send_text(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def send_text(%Plug.Conn{} = conn, text) when is_binary(text) do
    result = %{
      content: [
        %{
          type: "text",
          text: text
        }
      ],
      isError: false
    }

    send_success(conn, result)
  end

  defp send_success(%Plug.Conn{} = conn, result) do
    request_id = conn.body_params["id"]
    response = JsonRpc2.success_response(request_id, result)

    Method.send_json(conn, response)
  end
end
