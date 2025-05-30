defmodule Vancouver.Methods.ToolsCall do
  @moduledoc false

  import Vancouver.Method
  alias Vancouver.JsonRpc2

  def run(%Plug.Conn{} = conn, tools) do
    request = conn.body_params
    name = request["params"]["name"]
    arguments = request["params"]["arguments"]

    with {:ok, tool} <- get_tool(tools, name),
         :ok <- validate_arguments(tool, arguments) do
      tool.run(conn, arguments)
    else
      {:error, :not_found} -> tool_not_found(conn, request)
      {:error, {:invalid_params, reason}} -> invalid_params(conn, request, reason)
    end
  end

  defp get_tool(tools, name) do
    case Enum.find(tools, &(&1.name() == name)) do
      nil -> {:error, :not_found}
      tool -> {:ok, tool}
    end
  end

  defp validate_arguments(tool, arguments) do
    case JsonRpc2.validate_schema(tool.input_schema(), arguments) do
      :ok -> :ok
      {:error, reason} -> {:error, {:invalid_params, reason}}
    end
  end

  defp tool_not_found(conn, request) do
    data = %{original_request: request}
    response = JsonRpc2.error_response(:method_not_found, request["id"], data)

    send_json(conn, response)
  end

  defp invalid_params(conn, request, reason) do
    request_id = request["id"]
    data = %{error: reason, original_request: request}
    response = JsonRpc2.error_response(:invalid_params, request_id, data)

    send_json(conn, response)
  end
end
