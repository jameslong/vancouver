[![CI](https://github.com/jameslong/vancouver/actions/workflows/test.yml/badge.svg)](https://github.com/jameslong/vancouver/actions/workflows/test.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/vancouver.svg)](https://hex.pm/packages/vancouver)
[![Hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/vancouver/)
[![Hex.pm](https://img.shields.io/hexpm/dt/vancouver.svg)](https://hex.pm/packages/vancouver)
[![Hex.pm](https://img.shields.io/hexpm/dw/vancouver.svg)](https://hex.pm/packages/vancouver)

# Vancouver

Vancouver makes it easy to add [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction) functionality to your Phoenix/Bandit server. Vancouver handles initialization, request validation, and offers helper functions to simplify the creation of MCP tools and prompts. 

## Getting started

### 1. Add dependency

In `mix.exs`:

```elixir
defp deps do
  [
    {:vancouver, "~> 0.3"}
  ]
end
```

### 2. Create your tools/prompts

You can implement tools like this:

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
    send_text(conn, "#{a + b}")
  end
end
```

And prompts like this:

```elixir
defmodule MyApp.Prompts.CodeReview do
  use Vancouver.Prompt

  def name, do: "code_review"
  def description, do: "Asks the LLM to analyze code quality and suggest improvements"

  def arguments do
    [
      %{
        "name" => "code",
        "description" => "The code to review",
        "required" => true
      }
    ]
  end

  def run(conn, %{"code" => code}) do
    send_text(conn, "Please review this code: #{code}")
  end
end
```


### 3. Add config

In `config.ex`:

```elixir
config :vancouver,
  name: "My MCP Server",
  version: "1.0.0"
```

### 4. Add your MCP route

In `router.ex`:

```elixir
forward "/mcp", Vancouver.Router, 
  tools: [MyApp.Tools.CalculateSum],
  prompts: [MyApp.Prompts.CodeReview]
```

### 5. (Optional) Add to your MCP client

E.g. For Claude Desktop, you can modify your config `Settings -> Developer -> Edit config` as follows:

    {
        "mcpServers": {
            "MyApp": {
                "command": "npx",
                "args": [
                    "mcp-remote",
                    "http://localhost:4000/mcp"
                ]
            }
        }
    }

Run your server, and restart Claude to starting using your MCP tools. 🚀

## FAQ

### Does Vancouver support all parts of the Model Context Protocol specification?

Not yet. Vancouver currently supports:

- tools
- prompts
- sync responses (no streaming)

However, the library is simple enough that you should be able to modify it for your needs.

For more info on the protocol itself, see the [MCP User Guide](https://modelcontextprotocol.io/introduction).

### Is Vancouver stable / ready for production?

No. This library is in early development. Expect breaking changes.

### Why is this library called Vancouver?

Vancouver is the natural home of MCP (Mountain, Coffee, and Phoenix).