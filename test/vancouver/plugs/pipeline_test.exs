defmodule Vancouver.Plugs.PipelineTest do
  use ExUnit.Case, async: true

  import Plug.Conn
  import Vancouver.TestHelpers

  alias Vancouver.Plugs.Pipeline
  alias Vancouver.Prompts
  alias Vancouver.PromptTest
  alias Vancouver.Tools
  alias Vancouver.ToolTest

  describe "call/2" do
    test "with valid MCP request (ping) returns success" do
      conn =
        ping_request()
        |> request_conn()
        |> Pipeline.call([])

      assert_success(conn)
    end

    test "with valid MCP request (tool call) returns success" do
      conn =
        tools_call_request("calculate_sum", %{"a" => 1, "b" => 2})
        |> request_conn()
        |> assign(:vancouver, %{tools: [Tools.CalculateSum]})
        |> Pipeline.call([])

      assert_success(conn)
      assert ToolTest.text_response(conn)
    end

    test "with valid MCP request (prompt get) returns success" do
      conn =
        prompts_get_request("code_review", %{"code" => "def hello, do: \"Hello!\""})
        |> request_conn()
        |> assign(:vancouver, %{prompts: [Prompts.CodeReview]})
        |> Pipeline.call([])

      assert_success(conn)
      assert PromptTest.text_response(conn)
    end

    test "with invalid MCP request (invalid json rpc) returns error" do
      conn =
        %{ping_request() | "jsonrpc" => "1.0"}
        |> request_conn()
        |> Pipeline.call([])

      assert_error(conn, :invalid_request)
    end

    test "with unknown method returns error" do
      conn =
        %{ping_request() | "method" => "unknown"}
        |> request_conn()
        |> Pipeline.call([])

      assert_error(conn, :method_not_found)
    end
  end
end
