defmodule Vancouver.PromptTest do
  @moduledoc """
  Conveniences for testing Vancouver prompts.
  """

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
    |> check_type("audio")
    |> get_content()
  end

  @doc """
  Creates a valid request body for a prompt get request.

  ## Examples

      body = build_request("code_review", %{"code" => "def hello, do: \"Hello, World!\""})

  """
  @spec build_request(String.t(), map()) :: map()
  def build_request(prompt_name, arguments) do
    %{
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "prompts/get",
      "params" => %{
        "name" => prompt_name,
        "arguments" => arguments
      }
    }
  end

  @doc """
  Gets the role of the prompt.

  ## Examples

      assert get_role(conn) == "user"

      assert get_role(conn) == "assistant"

  """
  @spec get_role(Plug.Conn.t()) :: binary() | nil
  def get_role(conn) do
    response = JSON.decode!(conn.resp_body)

    case response["result"]["messages"] do
      [%{"role" => role}] -> role
      _ -> nil
    end
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
    |> check_type("image")
    |> get_content()
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
    |> check_type("text")
    |> get_text()
  end

  defp check_type(response, expected_type) do
    type = get_content_type(response)

    if expected_type == type do
      response
    else
      raise "expected response with content type #{expected_type}, got: #{type}"
    end
  end

  defp get_text(response), do: get_content(response)["text"]

  defp get_content(response) do
    case response["result"]["messages"] do
      [message] -> message["content"]
      message -> raise "expected response with single message item, got: #{inspect(message)}"
    end
  end

  defp get_content_type(response), do: get_content(response)["type"]
end
