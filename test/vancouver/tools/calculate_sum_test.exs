defmodule Vancouver.Tools.CalculateSumTest do
  use ExUnit.Case, async: true

  import Plug.Conn
  import Plug.Test

  alias Vancouver.Router
  alias Vancouver.Tools.CalculateSum
  alias Vancouver.ToolTest

  describe "run/2" do
    test "with arguments returns success" do
      conn = build_conn("calculate_sum", %{"a" => 1, "b" => 2})
      assert ToolTest.text_response(conn) == "3"
    end
  end

  defp build_conn(tool_name, tool_arguments) do
    body = ToolTest.call_request(tool_name, tool_arguments)

    :post
    |> conn("/", JSON.encode!(body))
    |> put_req_header("content-type", "application/json")
    |> Router.call(tools: [CalculateSum])
  end
end
