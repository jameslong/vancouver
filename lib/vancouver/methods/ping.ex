defmodule Vancouver.Methods.Ping do
  @moduledoc false

  import Vancouver.Method
  alias Vancouver.JsonRpc2

  def run(conn) do
    request = conn.body_params
    response = JsonRpc2.success_response(request["id"], %{})

    send_json(conn, response)
  end
end
