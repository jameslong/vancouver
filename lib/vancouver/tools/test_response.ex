defmodule Vancouver.Tools.TestResponse do
  @moduledoc false

  use Vancouver.Tool

  def name, do: "test_response"
  def description, do: "Returns success/error responses for all context types"

  def input_schema do
    %{
      "type" => "object",
      "properties" => %{
        "response_type" => %{
          "type" => "string",
          "enum" => ["audio", "error", "image", "json", "text"]
        }
      },
      "required" => ["response_type"]
    }
  end

  def run(conn, %{"response_type" => "audio"}) do
    send_audio(conn, "base64-encoded-audio-data", "audio/wav")
  end

  def run(conn, %{"response_type" => "error"}) do
    send_error(conn, "Error message")
  end

  def run(conn, %{"response_type" => "image"}) do
    send_image(conn, "base64-encoded-data", "image/png")
  end

  def run(conn, %{"response_type" => "json"}) do
    send_json(conn, %{"key" => "value"})
  end

  def run(conn, %{"response_type" => "text"}) do
    send_text(conn, "Success text")
  end
end
