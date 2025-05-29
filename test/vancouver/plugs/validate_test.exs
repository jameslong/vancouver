defmodule Vancouver.Plugs.ValidateTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Plugs.Validate

  describe "call/2" do
    test "with valid request returns conn" do
      conn =
        initialize_request()
        |> request_conn()
        |> Validate.call([])

      assert is_nil(conn.status)
      assert is_nil(conn.resp_body)
      refute conn.halted
    end

    test "with invalid request returns error response" do
      conn =
        %{initialize_request() | "jsonrpc" => "1.0"}
        |> request_conn()
        |> Validate.call([])

      assert_error(conn, :invalid_request)
    end
  end
end
