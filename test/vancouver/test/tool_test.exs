defmodule Vancouver.Test.ToolTest do
  use ExUnit.Case, async: true

  import Plug.Conn
  import Plug.Test

  alias Vancouver.JsonRpc2
  alias Vancouver.ToolTest

  describe "call_request/3" do
    test "creates a valid call request" do
      tool_name = "test_tool"
      arguments = %{"arg1" => "value1", "arg2" => "value2"}

      assert ToolTest.call_request(tool_name, arguments) == %{
               "jsonrpc" => "2.0",
               "id" => 1,
               "method" => "tools/call",
               "params" => %{
                 "name" => tool_name,
                 "arguments" => arguments
               }
             }
    end
  end

  describe "audio_response/1" do
    test "with valid conn returns content" do
      content = [%{"type" => "audio", "data" => "base64-audio-data", "mimeType" => "audio/wav"}]
      conn = build_success_conn(content)

      response = ToolTest.audio_response(conn)
      assert response["data"] == "base64-audio-data"
      assert response["mimeType"] == "audio/wav"
    end

    test "with invalid conn raises error" do
      assert_raise RuntimeError, "expected response with single content item, got: []", fn ->
        content = []
        conn = build_success_conn(content)
        ToolTest.audio_response(conn)
      end

      assert_raise RuntimeError, "expected response with content type audio, got: text", fn ->
        content = [%{"type" => "text", "text" => "text"}]
        conn = build_success_conn(content)
        ToolTest.audio_response(conn)
      end

      assert_raise RuntimeError, "expected success response, got: error", fn ->
        content = [%{"type" => "text", "text" => "oops"}]
        conn = build_error_conn(content)
        ToolTest.audio_response(conn)
      end
    end
  end

  describe "error_response/1" do
    test "with valid conn returns content" do
      content = [%{"type" => "text", "text" => "oops"}]
      conn = build_error_conn(content)

      assert ToolTest.error_response(conn) == "oops"
    end

    test "with invalid conn raises error" do
      assert_raise RuntimeError, "expected response with single content item, got: []", fn ->
        content = []
        conn = build_error_conn(content)
        ToolTest.error_response(conn)
      end

      assert_raise RuntimeError, "expected response with content type text, got: image", fn ->
        content = [%{"type" => "image", "data" => "base64-image-data", "mimeType" => "image/png"}]
        conn = build_error_conn(content)
        ToolTest.error_response(conn)
      end

      assert_raise RuntimeError, "expected error response, got: success", fn ->
        content = [%{"type" => "text", "text" => "Hello, world!"}]
        conn = build_success_conn(content)
        ToolTest.error_response(conn)
      end
    end
  end

  describe "image_response/1" do
    test "with valid conn returns content" do
      content = [%{"type" => "image", "data" => "base64-image-data", "mimeType" => "image/png"}]
      conn = build_success_conn(content)

      response = ToolTest.image_response(conn)
      assert response["data"] == "base64-image-data"
      assert response["mimeType"] == "image/png"
    end

    test "with invalid conn raises error" do
      assert_raise RuntimeError, "expected response with single content item, got: []", fn ->
        content = []
        conn = build_success_conn(content)
        ToolTest.image_response(conn)
      end

      assert_raise RuntimeError, "expected response with content type image, got: text", fn ->
        content = [%{"type" => "text", "text" => "Hello, world!"}]
        conn = build_success_conn(content)
        ToolTest.image_response(conn)
      end

      assert_raise RuntimeError, "expected success response, got: error", fn ->
        content = [%{"type" => "text", "text" => "oops"}]
        conn = build_error_conn(content)
        ToolTest.image_response(conn)
      end
    end
  end

  describe "json_response/1" do
    test "with valid conn returns content" do
      content = [%{"type" => "text", "text" => "{\"key\": \"value\"}"}]
      conn = build_success_conn(content)

      assert %{"key" => "value"} = ToolTest.json_response(conn)
    end

    test "with invalid conn raises error" do
      assert_raise RuntimeError, "expected response with single content item, got: []", fn ->
        content = []
        conn = build_success_conn(content)
        ToolTest.json_response(conn)
      end

      assert_raise RuntimeError, "expected response with content type text, got: image", fn ->
        content = [%{"type" => "image", "data" => "base64-image-data", "mimeType" => "image/png"}]
        conn = build_success_conn(content)
        ToolTest.json_response(conn)
      end

      assert_raise RuntimeError, "expected response content with valid JSON, got: %{}", fn ->
        content = [%{"type" => "text", "text" => "%{}"}]
        conn = build_success_conn(content)
        ToolTest.json_response(conn)
      end

      assert_raise RuntimeError, "expected success response, got: error", fn ->
        content = [%{"type" => "text", "text" => "oops"}]
        conn = build_error_conn(content)
        ToolTest.json_response(conn)
      end
    end
  end

  describe "text_response/1" do
    test "with valid conn returns content" do
      text = "Hello, world!"
      content = [%{"type" => "text", "text" => text}]
      conn = build_success_conn(content)

      assert ToolTest.text_response(conn) == text
    end

    test "with invalid conn raises error" do
      assert_raise RuntimeError, "expected response with single content item, got: []", fn ->
        content = []
        conn = build_success_conn(content)
        ToolTest.text_response(conn)
      end

      assert_raise RuntimeError, "expected response with content type text, got: image", fn ->
        content = [%{"type" => "image", "data" => "base64-image-data", "mimeType" => "image/png"}]
        conn = build_success_conn(content)
        ToolTest.text_response(conn)
      end

      assert_raise RuntimeError, "expected success response, got: error", fn ->
        content = [%{"type" => "text", "text" => "oops"}]
        conn = build_error_conn(content)
        ToolTest.text_response(conn)
      end
    end
  end

  defp build_success_conn(content, request_id \\ 1) do
    build_response_conn(content, request_id, false)
  end

  defp build_error_conn(content, request_id \\ 1) do
    build_response_conn(content, request_id, true)
  end

  def build_response_conn(content, request_id \\ 1, is_error \\ false) do
    result = %{"content" => content, "isError" => is_error}
    body = JsonRpc2.success_response(request_id, result)

    conn(:post, "/")
    |> put_req_header("content-type", "application/json")
    |> Map.put(:resp_body, JSON.encode!(body))
    |> put_status(200)
  end
end
