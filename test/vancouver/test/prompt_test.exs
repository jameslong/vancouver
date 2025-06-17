defmodule Vancouver.Test.PromptTest do
  use ExUnit.Case, async: true

  import Plug.Conn
  import Plug.Test

  alias Vancouver.JsonRpc
  alias Vancouver.PromptTest

  describe "build_get_request/2" do
    test "creates a valid get request" do
      prompt_name = "test_prompt"
      arguments = %{"arg1" => "value1", "arg2" => "value2"}

      assert PromptTest.build_get_request(prompt_name, arguments) == %{
               "jsonrpc" => "2.0",
               "id" => 1,
               "method" => "prompts/get",
               "params" => %{
                 "name" => prompt_name,
                 "arguments" => arguments
               }
             }
    end
  end

  describe "audio_response/1" do
    test "with valid conn returns content" do
      messages = [
        %{
          "role" => "user",
          "content" => %{
            "type" => "audio",
            "data" => "base64-audio-data",
            "mimeType" => "audio/wav"
          }
        }
      ]

      conn = build_success_conn(messages)

      response = PromptTest.audio_response(conn)
      assert response["data"] == "base64-audio-data"
      assert response["mimeType"] == "audio/wav"
    end

    test "with invalid conn raises error" do
      assert_raise RuntimeError, "expected response with single message item, got: []", fn ->
        messages = []
        conn = build_success_conn(messages)

        PromptTest.audio_response(conn)
      end

      assert_raise RuntimeError, "expected response with content type audio, got: text", fn ->
        messages = [
          %{
            "role" => "user",
            "content" => %{"type" => "text", "text" => "text"}
          }
        ]

        conn = build_success_conn(messages)

        PromptTest.audio_response(conn)
      end
    end
  end

  describe "image_response/1" do
    test "with valid conn returns content" do
      messages = [
        %{
          "role" => "user",
          "content" => %{
            "type" => "image",
            "data" => "base64-image-data",
            "mimeType" => "image/png"
          }
        }
      ]

      conn = build_success_conn(messages)

      response = PromptTest.image_response(conn)
      assert response["data"] == "base64-image-data"
      assert response["mimeType"] == "image/png"
    end

    test "with invalid conn raises error" do
      assert_raise RuntimeError, "expected response with single message item, got: []", fn ->
        messages = []
        conn = build_success_conn(messages)
        PromptTest.image_response(conn)
      end

      assert_raise RuntimeError, "expected response with content type image, got: text", fn ->
        messages = [
          %{
            "role" => "user",
            "content" => %{"type" => "text", "text" => "Hello, world!"}
          }
        ]

        conn = build_success_conn(messages)
        PromptTest.image_response(conn)
      end
    end
  end

  describe "text_response/1" do
    test "with valid conn returns content" do
      messages = [
        %{
          "role" => "user",
          "content" => %{"type" => "text", "text" => "Hello, world!"}
        }
      ]

      conn = build_success_conn(messages)

      assert PromptTest.text_response(conn) == "Hello, world!"
    end

    test "with invalid conn raises error" do
      assert_raise RuntimeError, "expected response with single message item, got: []", fn ->
        messages = []
        conn = build_success_conn(messages)

        PromptTest.text_response(conn)
      end

      assert_raise RuntimeError, "expected response with content type text, got: image", fn ->
        messages = [
          %{
            "role" => "user",
            "content" => %{
              "type" => "image",
              "data" => "base64-image-data",
              "mimeType" => "image/png"
            }
          }
        ]

        conn = build_success_conn(messages)

        PromptTest.text_response(conn)
      end
    end
  end

  defp build_success_conn(messages, request_id \\ 1) do
    result = %{"messages" => messages}
    body = JsonRpc.success_response(request_id, result)

    conn(:post, "/")
    |> put_req_header("content-type", "application/json")
    |> Map.put(:resp_body, JSON.encode!(body))
    |> put_status(200)
  end
end
