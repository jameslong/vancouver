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
defmodule MyProject.Tools.ExampleTool do
  @moduledoc """
  Implements the `ExampleTool` tool.
  """

  use Vancouver.Tool

  def name, do: "example_tool"
  def description, do: "An example tool for demonstration purposes"

  def input_schema do
    %{
      "type" => "object",
      "description" => "Input parameters for the example tool",
      "properties" => %{
        "example_param" => %{
          "type" => "string",
          "description" => "An example parameter for the tool"
        }
      },
      "required" => ["example_param"],
      "additionalProperties" => false
    }
  end

  def run(conn, %{"example_param" => example_param}) do
    send_text(conn, "Example tool executed successfully with param: #{example_param}")
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
    MyProject.Tools.ExampleTool
  ]
```

### 4. Add your MCP route

In `router.ex`:

```elixir
post("/mcp/v1", do: Vancouver.Plugs.Pipeline.call(conn))
```


