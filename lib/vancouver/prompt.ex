defmodule Vancouver.Prompt do
  @moduledoc false

  alias Vancouver.JsonRpc2
  alias Vancouver.Method

  @type role :: :user | :assistant

  @callback name() :: String.t()

  @doc """
  Human readable description of what the prompt does.
  """
  @callback description() :: String.t()

  @doc """
  JSON Schema defining the prompt's arguments.
  """
  @callback arguments() :: [map()]

  @doc """
  Execute the prompt with the given arguments.
  """
  @callback run(conn :: Plug.Conn.t(), params :: map()) :: Plug.Conn.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour Vancouver.Prompt
      import Vancouver.Prompt

      def definition do
        %{
          "name" => name(),
          "description" => description(),
          "arguments" => arguments()
        }
      end
    end
  end

  @doc """
  Sends audio response.

  Accepts a `:role` option, which can be either `:user` or `:assistant`, defaulting to `:user`.

  ## Examples

      iex> send_audio(conn, "base64-encoded-audio-data", "audio/wav")

      iex> send_audio(conn, "base64-encoded-audio-data", "audio/wav", role: :user)

      iex> send_audio(conn, "base64-encoded-audio-data", "audio/wav", role: :assistant)

  """
  @spec send_audio(Plug.Conn.t(), binary(), binary(), Keyword.t()) :: Plug.Conn.t()
  def send_audio(%Plug.Conn{} = conn, base64_data, mime_type, opts \\ [])
      when is_binary(base64_data) and is_binary(mime_type) do
    role = get_role(opts)

    result = %{
      "messages" => [
        %{
          "role" => role,
          "content" => %{
            "type" => "audio",
            "data" => base64_data,
            "mimeType" => mime_type
          }
        }
      ]
    }

    send_success(conn, result)
  end

  @doc """
  Sends image response.

  Accepts a `:role` option, which can be either `:user` or `:assistant`, defaulting to `:user`.

  ## Examples

      iex> send_image(conn, "base64-encoded-data", "image/png")

      iex> send_image(conn, "base64-encoded-data", "image/png", role: :user)

      iex> send_image(conn, "base64-encoded-data", "image/png", role: :assistant)

  """
  @spec send_image(Plug.Conn.t(), binary(), binary(), Keyword.t()) :: Plug.Conn.t()
  def send_image(%Plug.Conn{} = conn, base64_data, mime_type, opts \\ [])
      when is_binary(base64_data) and is_binary(mime_type) do
    role = get_role(opts)

    result = %{
      "messages" => [
        %{
          "role" => role,
          "content" => %{
            "type" => "image",
            "data" => base64_data,
            "mimeType" => mime_type
          }
        }
      ]
    }

    send_success(conn, result)
  end

  @doc """
  Sends text response.

  Accepts a `:role` option, which can be either `:user` or `:assistant`, defaulting to `:user`.

  ## Examples

      iex> send_text(conn, "hello")

      iex> send_text(conn, "hello", role: :user)

      iex> send_text(conn, "hello", role: :assistant)

  """
  @spec send_text(Plug.Conn.t(), binary(), Keyword.t()) :: Plug.Conn.t()
  def send_text(%Plug.Conn{} = conn, text, opts \\ []) when is_binary(text) do
    role = get_role(opts)

    result = %{
      "messages" => [
        %{
          "role" => role,
          "content" => %{
            "type" => "text",
            "text" => text
          }
        }
      ]
    }

    send_success(conn, result)
  end

  defp get_role(opts) do
    case Keyword.get(opts, :role, :user) do
      :user -> "user"
      :assistant -> "assistant"
      _ -> raise ArgumentError, "Invalid role: #{inspect(opts[:role])}"
    end
  end

  defp send_success(%Plug.Conn{} = conn, result) do
    request_id = conn.body_params["id"]
    response = JsonRpc2.success_response(request_id, result)

    Method.send_json(conn, response)
  end
end
