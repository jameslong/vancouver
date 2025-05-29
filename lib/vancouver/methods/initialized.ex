defmodule Vancouver.Methods.Initialized do
  @moduledoc """
  Handles the `initialized` method for the MCP protocol.
  """

  import Vancouver.Method

  def run(conn), do: send_json(conn, %{})
end
