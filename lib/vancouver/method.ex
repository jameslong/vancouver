defmodule Vancouver.Method do
  @moduledoc """
  Provides helper functions for methods.
  """

  import Plug.Conn

  def send_json(%Plug.Conn{} = conn, %{} = response) do
    conn
    |> json(response)
    |> halt()
  end

  def json(%Plug.Conn{} = conn, %{} = response) do
    body = JSON.encode!(response)
    status = conn.status || 200

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end
end
