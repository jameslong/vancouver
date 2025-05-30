# Vancouver

> [!WARNING]
>
> This library is under active development - expect breaking changes

Vancouver makes it easy to add [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction) functionality to your Phoenix/Bandit server. Vancouver handles initialization, request validation, and offers helper functions to simplify the creation of MCP tools. 

## Getting started

### 1. Add dependency

In `mix.exs`:

```elixir
defp deps do
  [
    {:vancouver, "~> 0.1.0"}
  ]
end
```

### 2. Create your tools

```elixir
defmodule MyApp.Tools.CalculateSum do
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
    send_text(conn, "\#{a + b}")
  end
end
```

### 3. Update the config

In `config.ex`:

```elixir
config :vancouver,
  name: "My MCP Server",
  version: "1.0.0",
  tools: [
    MyApp.Tools.CalculateSum
  ]
```

### 4. Add your MCP route

In `router.ex`:

```elixir
post("/mcp/v1", do: Vancouver.Plugs.Pipeline.call(conn))
```


