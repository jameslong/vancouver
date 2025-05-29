defmodule Vancouver.Methods.ToolsCallTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.ToolsCall

  describe "run/2" do
    test "with valid tool returns success response" do
      tools = [Vancouver.Tools.ExampleTool]
      request = tools_call_request("example_tool", %{"example_param" => "a param"})

      conn =
        request
        |> request_conn()
        |> ToolsCall.run(tools)

      assert_success(conn)
    end

    test "with invalid arguments returns error response" do
      tools = [Vancouver.Tools.ExampleTool]
      request = tools_call_request("example_tool", %{"invalid_param" => "a param"})

      conn =
        request
        |> request_conn()
        |> ToolsCall.run(tools)

      assert_error(conn, :invalid_params)
    end

    test "with tool not found returns error response" do
      tools = [Vancouver.Tools.ExampleTool]
      request = tools_call_request("invalid_tool", %{})

      conn =
        request
        |> request_conn()
        |> ToolsCall.run(tools)

      assert_error(conn, :method_not_found)
    end
  end
end
