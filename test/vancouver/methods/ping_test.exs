defmodule Vancouver.Methods.PingTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.Ping

  describe "run/2" do
    test "returns success response" do
      conn =
        ping_request()
        |> request_conn()
        |> Ping.run()

      assert_success(conn)
    end
  end
end
