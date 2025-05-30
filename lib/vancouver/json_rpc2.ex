defmodule Vancouver.JsonRpc2 do
  @moduledoc false

  @error_type_map %{
    parse_error: {-32700, "Parse error"},
    invalid_request: {-32600, "Invalid Request"},
    method_not_found: {-32601, "Method not found"},
    invalid_params: {-32602, "Invalid params"},
    internal_error: {-32603, "Internal error"}
  }
  @error_types Map.keys(@error_type_map)

  def success_response(request_id, result) do
    %{
      "jsonrpc" => "2.0",
      "id" => request_id,
      "result" => result
    }
  end

  def error_response(error_type, request_id, data) when error_type in @error_types do
    {code, message} = Map.get(@error_type_map, error_type)

    %{
      "jsonrpc" => "2.0",
      "id" => request_id,
      "error" => %{
        "code" => code,
        "message" => message,
        "data" => data
      }
    }
  end

  @schema_path Application.app_dir(:vancouver, "priv/schema.json")
  @schema_json @schema_path |> File.read!() |> JSON.decode!()
  @resolved_schema ExJsonSchema.Schema.resolve(@schema_json)

  def validate_schema(schema, data) do
    schema
    |> ExJsonSchema.Validator.validate(data)
    |> parse_result()
  end

  def validate_schema_fragment(schema, path, data) do
    schema
    |> ExJsonSchema.Validator.validate_fragment(path, data)
    |> parse_result()
  end

  def validate_mcp_request(schema_name, data) do
    validate_schema_fragment(@resolved_schema, "#/definitions/#{schema_name}", data)
  end

  def parse_result(:ok), do: :ok

  def parse_result({:error, errors}) do
    message =
      errors
      |> Enum.map(fn {message, path} -> "#{path} => #{message}" end)
      |> Enum.join(" ")

    {:error, message}
  end
end
