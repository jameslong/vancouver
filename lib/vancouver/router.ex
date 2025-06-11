defmodule Vancouver.Router do
  @moduledoc false

  use Plug.Router, copy_opts_to_assign: :vancouver

  alias Vancouver.Plugs.Pipeline

  plug(:match)
  plug(:dispatch)

  post("/", do: Pipeline.call(conn, Pipeline.init([])))
  match(_, do: send_resp(conn, 404, "Not found"))
end
