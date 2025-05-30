defmodule Vancouver.Methods.Unknown do
  @moduledoc false

  import Vancouver.Method
  alias Vancouver.JsonRpc2

  def run(%Plug.Conn{} = conn) do
    request = conn.body_params
    request_id = request["id"]
    data = %{original_request: request}
    response = JsonRpc2.error_response(:method_not_found, request_id, data)

    send_json(conn, response)
  end
end
