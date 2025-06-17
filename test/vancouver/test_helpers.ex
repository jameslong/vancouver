defmodule Vancouver.TestHelpers do
  @moduledoc """
  Helper functions for testing MCP methods.
  """

  import ExUnit.Assertions
  import Plug.Conn
  import Plug.Test

  def request(method, params \\ %{}, id \\ 1) do
    %{
      "jsonrpc" => "2.0",
      "method" => method,
      "params" => params,
      "id" => id
    }
  end

  def ping_request(id \\ 1) do
    request("ping", %{}, id)
  end

  def initialize_request(id \\ 1) do
    params = %{
      "capabilities" => %{"tools" => %{}},
      "protocolVersion" => "2024-11-05",
      "serverInfo" => %{
        "name" => "Mcp Server",
        "version" => "1.0.0"
      }
    }

    request("initialize", params, id)
  end

  def initialized_request do
    %{
      "jsonrpc" => "2.0",
      "method" => "initialized"
    }
  end

  def prompts_list_request(id \\ 1) do
    request("prompts/list", %{}, id)
  end

  def prompts_get_request(prompt_name, arguments, id \\ 1) do
    request("prompts/get", %{"name" => prompt_name, "arguments" => arguments}, id)
  end

  def tools_list_request(id \\ 1) do
    request("tools/list", %{}, id)
  end

  def tools_call_request(tool_name, arguments, id \\ 1) do
    request("tools/call", %{"name" => tool_name, "arguments" => arguments}, id)
  end

  def unknown_request(id \\ 1) do
    request("unknown", %{}, id)
  end

  def request_conn(body \\ %{}) do
    conn(:post, "/")
    |> put_req_header("content-type", "application/json")
    |> Map.put(:body_params, body)
  end

  def result(conn) do
    case JSON.decode!(conn.resp_body) do
      %{"result" => result} -> result
      _ -> raise "expected response to contain 'result' key, got: #{inspect(conn.resp_body)}"
    end
  end

  def assert_success(conn) do
    assert conn.status == 200
    assert conn.halted
    assert %{"jsonrpc" => "2.0", "id" => _id, "result" => _result} = JSON.decode!(conn.resp_body)
  end

  def assert_notification_received(conn) do
    assert conn.status == 200
    assert %{} == JSON.decode!(conn.resp_body)
    assert conn.halted
  end

  def assert_error(conn, :invalid_request) do
    assert conn.status == 400
    assert conn.halted

    assert %{
             "error" => %{
               "code" => -32600,
               "message" => "Invalid Request"
             }
           } = JSON.decode!(conn.resp_body)
  end

  def assert_error(conn, :method_not_found) do
    assert conn.status == 200
    assert conn.halted

    assert %{
             "error" => %{
               "code" => -32601,
               "message" => "Method not found"
             }
           } = JSON.decode!(conn.resp_body)
  end

  def assert_error(conn, :invalid_params) do
    assert conn.status == 200
    assert conn.halted

    assert %{
             "error" => %{
               "code" => -32602,
               "message" => "Invalid params"
             }
           } = JSON.decode!(conn.resp_body)
  end
end
