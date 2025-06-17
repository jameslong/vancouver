defmodule Vancouver.Methods.ToolsListTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.ToolsList
  alias Vancouver.Tools.CalculateSum

  describe "run/2" do
    test "with no tools returns success" do
      conn =
        tools_list_request()
        |> request_conn()
        |> ToolsList.run([])

      assert_success(conn)
      assert result(conn) == %{"tools" => []}
    end

    test "with tools returns success" do
      conn =
        tools_list_request()
        |> request_conn()
        |> ToolsList.run([CalculateSum])

      assert_success(conn)
      assert result(conn) == %{"tools" => [CalculateSum.definition()]}
    end
  end
end
