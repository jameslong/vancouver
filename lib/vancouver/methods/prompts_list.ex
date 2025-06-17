defmodule Vancouver.Methods.PromptsList do
  @moduledoc false

  import Vancouver.Method
  alias Vancouver.JsonRpc

  def run(%Plug.Conn{} = conn, prompts) do
    request = conn.body_params
    prompt_definitions = Enum.map(prompts, & &1.definition())
    response = JsonRpc.success_response(request["id"], %{prompts: prompt_definitions})

    send_json(conn, response)
  end
end
