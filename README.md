# WIP: Vancouver

Helper library to make it quick and easy to add MCP server capability to your Phoenix/Bandit project. Vancouver handles initialization, request validation, and offers helper functions to simplify the creation of MCP tools. 

Note, Vancouver is currently in-development, however, the dev UX will look something like this:

### 1. Add dependency

In `mix.exs`:

```elixir
defp deps do
  [
    {:vancouver, "~> 0.1.0"}
  ]
end
```

### 2. Add your tools

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
post("/mcp/v1", do: Vancouver.McpPipeline.call(conn, []))
```


