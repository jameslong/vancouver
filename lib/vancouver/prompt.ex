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
  Sends text response.

  ## Examples

      iex> send_text(conn, :user, "hello")

  """
  @spec send_text(Plug.Conn.t(), role(), binary()) :: Plug.Conn.t()
  def send_text(%Plug.Conn{} = conn, text, opts \\ []) when is_binary(text) do
    role =
      case Keyword.get(opts, :role, :user) do
        :user -> "user"
        :assistant -> "assistant"
        _ -> raise ArgumentError, "Invalid role: #{inspect(opts[:role])}"
      end

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

  defp send_success(%Plug.Conn{} = conn, result) do
    request_id = conn.body_params["id"]
    response = JsonRpc2.success_response(request_id, result)

    Method.send_json(conn, response)
  end
end
