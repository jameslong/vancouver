defmodule Vancouver.Prompt.PromptTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers

  alias Vancouver.Prompt

  describe "send_audio/2" do
    test "with valid audio data returns conn" do
      audio_data = "base64-audio-data"
      mime_type = "audio/wav"
      conn = Prompt.send_audio(request_conn(), audio_data, mime_type)

      assert conn.status == 200
      assert conn.halted

      assert result(conn) == %{
               "messages" => [
                 %{
                   "content" => %{
                     "type" => "audio",
                     "data" => audio_data,
                     "mimeType" => mime_type
                   },
                   "role" => "user"
                 }
               ]
             }
    end

    test "with valid role returns conn with user role" do
      for role <- [:user, :assistant] do
        audio_data = "base64-audio-data"
        mime_type = "audio/wav"
        role_string = to_string(role)
        conn = Prompt.send_audio(request_conn(), audio_data, mime_type, role: role)

        assert conn.status == 200
        assert conn.halted
        assert %{"messages" => [%{"role" => ^role_string}]} = result(conn)
      end
    end

    test "with invalid role raises exception" do
      audio_data = "base64-audio-data"
      mime_type = "audio/wav"

      assert_raise ArgumentError,
                   "expected role to be one of [\"user\", \"assistant\"], got: nil",
                   fn -> Prompt.send_audio(request_conn(), audio_data, mime_type, role: nil) end
    end

    test "with invalid audio data raises exception" do
      assert_raise FunctionClauseError, fn ->
        Prompt.send_audio(request_conn(), nil, nil)
      end
    end
  end

  describe "send_image/2" do
    test "with valid image data returns conn" do
      image_data = "base64-image-data"
      mime_type = "image/png"
      conn = Prompt.send_image(request_conn(), image_data, mime_type)

      assert conn.status == 200
      assert conn.halted

      assert result(conn) == %{
               "messages" => [
                 %{
                   "content" => %{
                     "type" => "image",
                     "data" => image_data,
                     "mimeType" => mime_type
                   },
                   "role" => "user"
                 }
               ]
             }
    end

    test "with valid role returns conn with user role" do
      for role <- [:user, :assistant] do
        image_data = "base64-image-data"
        mime_type = "image/png"
        role_string = to_string(role)
        conn = Prompt.send_image(request_conn(), image_data, mime_type, role: role)

        assert conn.status == 200
        assert conn.halted
        assert %{"messages" => [%{"role" => ^role_string}]} = result(conn)
      end
    end

    test "with invalid role raises exception" do
      image_data = "base64-image-data"
      mime_type = "image/png"

      assert_raise ArgumentError,
                   "expected role to be one of [\"user\", \"assistant\"], got: nil",
                   fn -> Prompt.send_image(request_conn(), image_data, mime_type, role: nil) end
    end

    test "with invalid image data raises exception" do
      assert_raise FunctionClauseError, fn ->
        Prompt.send_image(request_conn(), nil, nil)
      end
    end
  end

  describe "send_text/2" do
    test "with valid text returns conn" do
      text = "Hello, world!"
      conn = Prompt.send_text(request_conn(), text)

      assert conn.status == 200
      assert conn.halted

      assert result(conn) == %{
               "messages" => [
                 %{"content" => %{"type" => "text", "text" => text}, "role" => "user"}
               ]
             }
    end

    test "with valid role returns conn with user role" do
      for role <- [:user, :assistant] do
        text = "Hello, world!"
        role_string = to_string(role)
        conn = Prompt.send_text(request_conn(), text, role: role)

        assert conn.status == 200
        assert conn.halted
        assert %{"messages" => [%{"role" => ^role_string}]} = result(conn)
      end
    end

    test "with invalid role raises exception" do
      text = "Hello, world!"

      assert_raise ArgumentError,
                   "expected role to be one of [\"user\", \"assistant\"], got: nil",
                   fn -> Prompt.send_text(request_conn(), text, role: nil) end
    end

    test "with invalid text raises exception" do
      assert_raise FunctionClauseError, fn ->
        Prompt.send_text(request_conn(), nil)
      end
    end
  end
end
