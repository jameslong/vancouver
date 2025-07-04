defmodule Vancouver.Plugs.Validate do
  @moduledoc false

  import Vancouver.Method
  import Plug.Conn
  alias Vancouver.JsonRpc

  def init(_opts), do: false

  def call(%Plug.Conn{} = conn, _opts) do
    request = conn.body_params

    case JsonRpc.validate_mcp_request("JSONRPCMessage", request) do
      :ok ->
        conn

      {:error, reason} ->
        request_id = request["id"]
        data = %{original_request: request, error: reason}
        response = JsonRpc.error_response(:invalid_request, request_id, data)

        conn
        |> put_status(400)
        |> send_json(response)
    end
  end
end
