defmodule Vancouver.Plugs.Dispatch do
  @moduledoc false

  alias Vancouver.Methods

  def init(_opts), do: false

  def call(%Plug.Conn{} = conn, _opts) do
    request = conn.body_params
    method = request["method"]
    prompts = conn.assigns[:vancouver][:prompts] || []
    tools = conn.assigns[:vancouver][:tools] || []

    case method do
      "initialize" -> Methods.Initialize.run(conn)
      "notifications/initialized" -> Methods.Initialized.run(conn)
      "ping" -> Methods.Ping.run(conn)
      "prompts/list" -> Methods.PromptsList.run(conn, prompts)
      "prompts/get" -> Methods.PromptsGet.run(conn, prompts)
      "tools/list" -> Methods.ToolsList.run(conn, tools)
      "tools/call" -> Methods.ToolsCall.run(conn, tools)
      _ -> Methods.Unknown.run(conn)
    end
  end
end
