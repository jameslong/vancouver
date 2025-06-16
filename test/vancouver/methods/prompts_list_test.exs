defmodule Vancouver.Methods.PromptsListTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.PromptsList

  describe "run/2" do
    test "returns empty prompts list" do
      conn =
        tools_list_request()
        |> request_conn()
        |> PromptsList.run([])

      assert_success(conn)
    end
  end
end
