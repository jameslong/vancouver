defmodule Vancouver.Methods.InitializedTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.Initialized

  describe "run/2" do
    test "returns success response" do
      conn =
        initialized_request()
        |> request_conn()
        |> Initialized.run()

      assert_notification_received(conn)
    end
  end
end
