defmodule Vancouver.Prompts.CodeReview do
  @moduledoc false
  use Vancouver.Prompt

  def name, do: "code_review"
  def description, do: "Asks the LLM to analyze code quality and suggest improvements"

  def arguments do
    [
      %{
        "name" => "code",
        "description" => "The code to review",
        "required" => true
      }
    ]
  end

  def run(conn, %{"code" => code}) do
    send_text(conn, "Please review this code: #{code}")
  end
end
