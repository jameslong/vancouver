defmodule Vancouver.Methods.UnknownTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.Unknown

  describe "run/2" do
    test "returns method not found error" do
      conn =
        unknown_request()
        |> request_conn()
        |> Unknown.run()

      assert_error(conn, :method_not_found)
    end
  end
end
