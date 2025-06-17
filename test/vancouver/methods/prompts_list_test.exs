defmodule Vancouver.Methods.PromptsListTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.PromptsList
  alias Vancouver.Prompts.CodeReview

  describe "run/2" do
    test "with no prompts returns success" do
      conn =
        prompts_list_request()
        |> request_conn()
        |> PromptsList.run([])

      assert_success(conn)
      assert result(conn) == %{"prompts" => []}
    end
  end

  test "with prompts returns success" do
    conn =
      prompts_list_request()
      |> request_conn()
      |> PromptsList.run([CodeReview])

    assert_success(conn)
    assert result(conn) == %{"prompts" => [CodeReview.definition()]}
  end
end
