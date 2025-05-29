defmodule Vancouver.Methods.Ping do
  @moduledoc """
  Handles the `ping` method for the MCP protocol.
  """

  import Vancouver.Method
  alias Vancouver.JsonRpc2

  def run(conn) do
    request = conn.body_params
    response = JsonRpc2.success_response(request["id"], %{})

    send_json(conn, response)
  end
end
