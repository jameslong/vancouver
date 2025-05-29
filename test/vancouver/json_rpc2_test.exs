defmodule Vancouver.JsonRpc2Test do
  use ExUnit.Case, async: true

  alias Vancouver.JsonRpc2

  @error_type_map %{
    parse_error: {-32700, "Parse error"},
    invalid_request: {-32600, "Invalid Request"},
    method_not_found: {-32601, "Method not found"},
    invalid_params: {-32602, "Invalid params"},
    internal_error: {-32603, "Internal error"}
  }

  describe "success_response/2" do
    test "with valid request ID and result returns success response" do
      request_id = 1
      result = %{"key" => "value"}

      assert JsonRpc2.success_response(request_id, result) == %{
               "jsonrpc" => "2.0",
               "id" => request_id,
               "result" => result
             }
    end
  end

  describe "error_response/3" do
    test "with valid error type, returns error response" do
      for {error_type, {code, message}} <- @error_type_map do
        request_id = 1
        data = %{"key" => "value"}

        assert JsonRpc2.error_response(error_type, request_id, data) == %{
                 "jsonrpc" => "2.0",
                 "id" => request_id,
                 "error" => %{
                   "code" => code,
                   "message" => message,
                   "data" => data
                 }
               }
      end
    end
  end
end
