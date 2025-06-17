defmodule Vancouver.Tool.ToolTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers

  alias Vancouver.Tool

  describe "send_audio/2" do
    test "with valid audio data returns conn" do
      audio_data = "base64-audio-data"
      mime_type = "audio/wav"
      conn = Tool.send_audio(request_conn(), audio_data, mime_type)

      assert conn.status == 200
      assert conn.halted

      assert result(conn) == %{
               "content" => [%{"type" => "audio", "data" => audio_data, "mimeType" => mime_type}],
               "isError" => false
             }
    end

    test "with invalid audio data raises exception" do
      assert_raise FunctionClauseError, fn ->
        Tool.send_audio(request_conn(), nil, nil)
      end
    end
  end

  describe "send_error/2" do
    test "with valid error message returns conn" do
      error_message = "oops"
      conn = Tool.send_error(request_conn(), error_message)

      assert conn.status == 200
      assert conn.halted

      assert result(conn) == %{
               "content" => [%{"text" => "oops", "type" => "text"}],
               "isError" => true
             }
    end

    test "with invalid error message raises exception" do
      assert_raise FunctionClauseError, fn ->
        Tool.send_error(request_conn(), nil)
      end
    end
  end

  describe "send_image/2" do
    test "with valid image data returns conn" do
      image_data = "base64-image-data"
      mime_type = "image/png"
      conn = Tool.send_image(request_conn(), image_data, mime_type)

      assert conn.status == 200
      assert conn.halted

      assert result(conn) == %{
               "content" => [%{"type" => "image", "data" => image_data, "mimeType" => mime_type}],
               "isError" => false
             }
    end

    test "with invalid image data raises exception" do
      assert_raise FunctionClauseError, fn ->
        Tool.send_image(request_conn(), nil, nil)
      end
    end
  end

  describe "send_json/2" do
    test "with valid JSON data returns conn" do
      json_data = %{"key" => "value"}
      conn = Tool.send_json(request_conn(), json_data)

      assert conn.status == 200
      assert conn.halted

      assert result(conn) == %{
               "content" => [%{"type" => "text", "text" => JSON.encode!(json_data)}],
               "isError" => false
             }
    end

    test "with invalid JSON data raises exception" do
      assert_raise FunctionClauseError, fn ->
        Tool.send_json(request_conn(), nil)
      end
    end
  end

  describe "send_text/2" do
    test "with valid text returns conn" do
      text = "Hello, world!"
      conn = Tool.send_text(request_conn(), text)

      assert conn.status == 200
      assert conn.halted

      assert result(conn) == %{
               "content" => [%{"type" => "text", "text" => text}],
               "isError" => false
             }
    end

    test "with invalid text raises exception" do
      assert_raise FunctionClauseError, fn ->
        Tool.send_text(request_conn(), nil)
      end
    end
  end
end
