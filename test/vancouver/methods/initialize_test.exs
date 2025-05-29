defmodule Vancouver.Methods.InitializeTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.Initialize

  describe "run/2" do
    test "returns success response" do
      conn =
        initialize_request()
        |> request_conn()
        |> Initialize.run()

      assert_success(conn)
    end
  end
end
