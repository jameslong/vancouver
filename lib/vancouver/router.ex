defmodule Vancouver.Router do
  use Plug.Router

  alias Vancouver.Plugs.Pipeline

  plug(:match)
  plug(:dispatch)

  post "/" do
    Pipeline.call(conn, Pipeline.init([]))
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
