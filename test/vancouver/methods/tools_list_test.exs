defmodule Vancouver.Methods.ToolsListTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.ToolsList

  describe "run/2" do
    test "returns empty tools list" do
      conn =
        tools_list_request()
        |> request_conn()
        |> ToolsList.run([])

      assert_success(conn)
    end
  end
end
