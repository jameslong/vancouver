defmodule Vancouver.ToolTest do
  @moduledoc """
  Conveniences for testing Vancouver tools.
  """

  @doc """
  Creates a JSON-RPC call request for a tool.

  ## Examples

      body = call_request("calculate_sum", %{"a" => 1, "b" => 2})

  """
  @spec call_request(String.t(), map(), String.t()) :: map()
  def call_request(tool_name, arguments, id \\ "1") do
    %{
      "jsonrpc" => "2.0",
      "id" => id,
      "method" => "tools/call",
      "params" => %{
        "name" => tool_name,
        "arguments" => arguments
      }
    }
  end

  @doc """
  Asserts that the response was successful, and that audio content was returned.

  ## Examples

      content = audio_response(conn)
      assert content["data"] == "base64-audio-data"
      assert content["mimeType"] == "audio/wav"

  """
  @spec audio_response(Plug.Conn.t()) :: %{data: String.t(), mimeType: String.t()}
  def audio_response(conn) do
    response = JSON.decode!(conn.resp_body)

    response
    |> check_success()
    |> check_type("audio")
    |> get_content()
  end

  @doc """
  Asserts that the response was an error, and returns the error text.

  ## Examples

      assert error_response(conn) == "An error occurred"

  """
  @spec error_response(Plug.Conn.t()) :: String.t()
  def error_response(conn) do
    response = JSON.decode!(conn.resp_body)

    response
    |> check_error()
    |> check_type("text")
    |> get_text()
  end

  @doc """
  Asserts that the response was successful, and that image content was returned.

  ## Examples

      content = image_response(conn)
      assert content["data"] == "base64-image-data"
      assert content["mimeType"] == "image/png"

  """
  @spec image_response(Plug.Conn.t()) :: %{data: String.t(), mimeType: String.t()}
  def image_response(conn) do
    response = JSON.decode!(conn.resp_body)

    response
    |> check_success()
    |> check_type("image")
    |> get_content()
  end

  @doc """
  Asserts that the response was successful, and that JSON content was returned.

  ## Examples

      assert json_response(conn) == %{"key" => "value"}

  """
  @spec json_response(Plug.Conn.t()) :: term()
  def json_response(conn) do
    response = JSON.decode!(conn.resp_body)

    response
    |> check_success()
    |> check_type("text")
    |> get_json()
  end

  @doc """
  Asserts that the response was successful, and that text content was returned.

  ## Examples

      assert text_response(conn) == "Hello, world!"

  """
  @spec text_response(Plug.Conn.t()) :: String.t()
  def text_response(conn) do
    response = JSON.decode!(conn.resp_body)

    response
    |> check_success()
    |> check_type("text")
    |> get_text()
  end

  defp check_success(response) do
    if error?(response) do
      raise "expected success response, got: error"
    else
      response
    end
  end

  defp check_error(response) do
    if error?(response) do
      response
    else
      raise "expected error response, got: success"
    end
  end

  defp error?(response), do: response["result"]["isError"] || false

  defp check_type(response, expected_type) do
    type = get_content_type(response)

    if expected_type == type do
      response
    else
      raise "expected response with content type #{expected_type}, got: #{type}"
    end
  end

  defp get_json(response) do
    text = get_text(response)

    case JSON.decode(get_text(response)) do
      {:ok, json} -> json
      {:error, _} -> raise "expected response content with valid JSON, got: #{text}"
    end
  end

  defp get_text(response), do: get_content(response)["text"]

  defp get_content(response) do
    case response["result"]["content"] do
      [content] -> content
      content -> raise "expected response with single content item, got: #{inspect(content)}"
    end
  end

  defp get_content_type(response), do: get_content(response)["type"]
end
