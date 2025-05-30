defmodule Vancouver.Methods.Initialized do
  @moduledoc false

  import Vancouver.Method

  def run(conn), do: send_json(conn, %{})
end
