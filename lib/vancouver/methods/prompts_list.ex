defmodule Vancouver.Methods.PromptsList do
  @moduledoc false

  import Vancouver.Method
  alias Vancouver.JsonRpc2

  def run(%Plug.Conn{} = conn, prompts \\ []) do
    request = conn.body_params
    response = JsonRpc2.success_response(request["id"], %{prompts: prompts})

    send_json(conn, response)
  end
end
