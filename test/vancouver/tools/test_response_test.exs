defmodule Vancouver.Tools.TestResponseTest do
  use ExUnit.Case, async: false

  import Plug.Conn
  import Plug.Test

  alias Vancouver.Tools.TestResponse
  alias Vancouver.ToolTest

  describe "run/2" do
    setup do
      Application.put_env(:vancouver, :tools, [TestResponse])
      :ok
    end

    test "with audio response type returns success" do
      conn = build_conn("test_response", %{"response_type" => "audio"})

      audio = ToolTest.audio_response(conn)
      assert audio["data"] == "base64-encoded-audio-data"
      assert audio["mimeType"] == "audio/wav"
    end

    test "with error response type returns error" do
      conn = build_conn("test_response", %{"response_type" => "error"})
      assert ToolTest.error_response(conn) == "Error message"
    end

    test "with image response type returns success" do
      conn = build_conn("test_response", %{"response_type" => "image"})

      image = ToolTest.image_response(conn)
      assert image["data"] == "base64-encoded-data"
      assert image["mimeType"] == "image/png"
    end

    test "with json response type returns success" do
      conn = build_conn("test_response", %{"response_type" => "json"})
      assert ToolTest.json_response(conn) == %{"key" => "value"}
    end

    test "with text response type returns success" do
      conn = build_conn("test_response", %{"response_type" => "text"})
      assert ToolTest.text_response(conn) == "Success text"
    end
  end

  defp build_conn(tool_name, tool_arguments) do
    body = ToolTest.call_request(tool_name, tool_arguments)

    :post
    |> conn("/", JSON.encode!(body))
    |> put_req_header("content-type", "application/json")
    |> Vancouver.Router.call(Vancouver.Router.init([]))
  end
end
