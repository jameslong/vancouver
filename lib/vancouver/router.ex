defmodule Vancouver.Router do
  @moduledoc false

  use Plug.Router

  alias Vancouver.Plugs.Pipeline

  plug(:match)
  plug(:dispatch)

  forward("/", to: Pipeline)
end
