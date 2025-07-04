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
  - `send_audio/3` - sends an audio response
  - `send_image/3` - sends an image response
  - `send_text/2` - sends a text response
  - `send_error/2` - sends an error response
  """

  alias Vancouver.JsonRpc
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
    end
  end

  @doc """
  Sends audio response.

  ## Examples

      iex> send_audio(conn, "base64-encoded-audio-data", "audio/wav")

  """
  @spec send_audio(Plug.Conn.t(), binary(), binary()) :: Plug.Conn.t()
  def send_audio(%Plug.Conn{} = conn, base64_data, mime_type)
      when is_binary(base64_data) and is_binary(mime_type) do
    result = %{
      "content" => [%{"type" => "audio", "data" => base64_data, "mimeType" => mime_type}],
      "isError" => false
    }

    send_success(conn, result)
  end

  @doc """
  Sends an error response.

  ## Examples

      iex> send_error(conn, "an error occurred")

  """
  @spec send_error(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def send_error(%Plug.Conn{} = conn, message) when is_binary(message) do
    result = %{
      "content" => [%{"type" => "text", "text" => message}],
      "isError" => true
    }

    send_success(conn, result)
  end

  @doc """
  Sends image response.

  ## Examples

      iex> send_image(conn, "base64-encoded-data", "image/png")

  """
  @spec send_image(Plug.Conn.t(), binary(), binary()) :: Plug.Conn.t()
  def send_image(%Plug.Conn{} = conn, base64_data, mime_type)
      when is_binary(base64_data) and is_binary(mime_type) do
    result = %{
      "content" => [%{"type" => "image", "data" => base64_data, "mimeType" => mime_type}],
      "isError" => false
    }

    send_success(conn, result)
  end

  @doc """
  Sends JSON response.

  ## Examples

      iex> send_json(conn, %{id: 123})

  """
  @spec send_json(Plug.Conn.t(), term()) :: Plug.Conn.t()
  def send_json(%Plug.Conn{} = conn, data) when not is_nil(data) do
    send_text(conn, JSON.encode!(data))
  end

  @doc """
  Sends text response.

  ## Examples

      iex> send_text(conn, "hello")

  """
  @spec send_text(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def send_text(%Plug.Conn{} = conn, text) when is_binary(text) do
    result = %{
      "content" => [%{"type" => "text", "text" => text}],
      "isError" => false
    }

    send_success(conn, result)
  end

  defp send_success(%Plug.Conn{} = conn, result) do
    request_id = conn.body_params["id"]
    response = JsonRpc.success_response(request_id, result)

    Method.send_json(conn, response)
  end
end
