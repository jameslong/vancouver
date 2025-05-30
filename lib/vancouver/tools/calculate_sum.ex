defmodule Vancouver.Tools.CalculateSum do
  @moduledoc false

  use Vancouver.Tool

  def name, do: "calculate_sum"
  def description, do: "Add two numbers together"

  def input_schema do
    %{
      "type" => "object",
      "properties" => %{
        "a" => %{"type" => "number"},
        "b" => %{"type" => "number"}
      },
      "required" => ["a", "b"]
    }
  end

  def run(conn, %{"a" => a, "b" => b}) do
    send_text(conn, "#{a + b}")
  end
end
