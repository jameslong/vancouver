defmodule Vancouver.Tools.ExampleTool do
  @moduledoc """
  Implements the `ExampleTool` tool.
  """

  use Vancouver.Tool

  def name, do: "example_tool"
  def description, do: "An example tool for demonstration purposes"

  def input_schema do
    %{
      "type" => "object",
      "description" => "Input parameters for the example tool",
      "properties" => %{
        "example_param" => %{
          "type" => "string",
          "description" => "An example parameter for the tool"
        }
      },
      "required" => ["example_param"],
      "additionalProperties" => false
    }
  end

  def run(conn, %{"example_param" => example_param}) do
    send_text(conn, "Executing example tool with param: #{example_param}")
  end
end
