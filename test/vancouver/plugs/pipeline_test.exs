defmodule Vancouver.Plugs.PipelineTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Plugs.Pipeline

  describe "call/2" do
    test "with valid json rpc2 request returns success" do
      conn =
        ping_request()
        |> request_conn()
        |> Pipeline.call([])

      assert_success(conn)
    end

    test "with invalid json rpc2 request returns error" do
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
