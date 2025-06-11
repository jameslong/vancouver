defmodule Vancouver.Plugs.Pipeline do
  @moduledoc false

  use Plug.Builder, copy_opts_to_assign: :vancouver

  alias Vancouver.Plugs

  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: JSON)
  plug(Plugs.Validate)
  plug(Plugs.Dispatch)
end
