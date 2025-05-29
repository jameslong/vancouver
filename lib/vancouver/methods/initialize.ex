defmodule Vancouver.Methods.Initialize do
  @moduledoc """
  Handles the `initialize` method for the MCP protocol.
  """

  import Vancouver.Method
  alias Vancouver.JsonRpc2

  def run(conn) do
    request = conn.body_params
    name = Application.get_env(:vancouver, :name, "MCP Server")
    version = Application.get_env(:vancouver, :version, "1.0.0")

    result = %{
      "capabilities" => %{"tools" => %{}},
      "protocolVersion" => "2024-11-05",
      "serverInfo" => %{
        "name" => name,
        "version" => version
      }
    }

    response = JsonRpc2.success_response(request["id"], result)

    send_json(conn, response)
  end
end
