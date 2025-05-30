defmodule Vancouver.Methods.ToolsList do
  @moduledoc false

  import Vancouver.Method
  alias Vancouver.JsonRpc2

  def run(%Plug.Conn{} = conn, tools) do
    request = conn.body_params
    tool_definitions = Enum.map(tools, & &1.definition())
    response = JsonRpc2.success_response(request["id"], %{tools: tool_definitions})

    send_json(conn, response)
  end
end
