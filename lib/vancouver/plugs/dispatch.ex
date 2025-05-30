defmodule Vancouver.Plugs.Dispatch do
  @moduledoc false

  alias Vancouver.Methods

  def init(_opts), do: false

  def call(%Plug.Conn{} = conn, _opts) do
    request = conn.body_params
    method = request["method"]
    tools = Application.get_env(:vancouver, :tools, [])

    case method do
      "initialize" -> Methods.Initialize.run(conn)
      "notifications/initialized" -> Methods.Initialized.run(conn)
      "ping" -> Methods.Ping.run(conn)
      "tools/list" -> Methods.ToolsList.run(conn, tools)
      "tools/call" -> Methods.ToolsCall.run(conn, tools)
      _ -> Methods.Unknown.run(conn)
    end
  end
end
