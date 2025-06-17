defmodule Vancouver.Methods.PromptsGetTest do
  use ExUnit.Case, async: true

  import Vancouver.TestHelpers
  alias Vancouver.Methods.PromptsGet

  describe "run/2" do
    test "with valid prompt returns success response" do
      prompts = [Vancouver.Prompts.CodeReview]
      request = prompts_get_request("code_review", %{"code" => "def hello, do: \"Hello!\""})

      conn =
        request
        |> request_conn()
        |> PromptsGet.run(prompts)

      assert_success(conn)
    end

    test "with invalid arguments returns error response" do
      prompts = [Vancouver.Prompts.CodeReview]
      request = prompts_get_request("code_review", %{"code" => 1})

      conn =
        request
        |> request_conn()
        |> PromptsGet.run(prompts)

      assert_error(conn, :invalid_params)
    end

    test "with prompt not found returns error response" do
      prompts = [Vancouver.Prompts.CodeReview]
      request = prompts_get_request("invalid_prompt", %{})

      conn =
        request
        |> request_conn()
        |> PromptsGet.run(prompts)

      assert_error(conn, :method_not_found)
    end
  end
end
