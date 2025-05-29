defmodule Vancouver.Methods.ToolsCall do
  @moduledoc """
  Handles the `tools/call` method for the MCP protocol.
  """

  import Vancouver.Method
  alias Vancouver.JsonRpc2

  def run(%Plug.Conn{} = conn, tools) do
    request = conn.body_params
    name = request["params"]["name"]
    arguments = request["params"]["arguments"]

    with {:ok, tool} <- get_tool(tools, name),
         :ok <- validate_arguments(tool, arguments) do
      call_tool(conn, request, tool, arguments)
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

  defp call_tool(conn, request, tool, arguments) do
    result =
      case tool.run(conn, arguments) do
        {:ok, result} -> tool_success_result(result)
        {:error, reason} -> tool_error_result(reason)
      end

    response = JsonRpc2.success_response(request["id"], result)

    send_json(conn, response)
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

  def tool_success_result(content), do: tool_result(content, false)

  def tool_error_result(reason), do: tool_result(reason, true)

  def tool_result(content, is_error \\ false) do
    text_content =
      case content do
        content when is_binary(content) -> content
        _ -> JSON.encode!(content)
      end

    %{
      "content" => [%{type: "text", text: text_content}],
      "isError" => is_error
    }
  end
end
