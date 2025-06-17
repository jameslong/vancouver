# Changelog

## [v0.3.0] - 2025-06-17

### Added
- **Prompts Support**: Adds support for MCP prompts, including `Vancouver.PromptTest` for easier testing (#13, #14)
- **Router Integration**: Prompts can now be configured as options in `Vancouver.Router` (#13)

  ```elixir
  forward "/mcp", Vancouver.Router, 
    tools: [MyApp.Tools.CalculateSum],
    prompts: [MyApp.Prompts.CodeReview]
  ```

### Changed
- **Test Helper Rename**: `Vancouver.ToolTest.call_request/2` has been renamed to `Vancouver.ToolTest.build_call_request/2`

### Migration Guide
Update your test files to use the new function name:

```elixir
# Before (v0.2.x)
request = Vancouver.ToolTest.call_request(tool_name, arguments)

# After (v0.3.0+)
request = Vancouver.ToolTest.build_call_request(tool_name, arguments)
```

## [v0.2.0](https://github.com/your-repo/vancouver/releases/tag/v0.2.0) - 2025-06-12

### Breaking Changes
- **Tool Configuration**: Tools must now be passed as options to `Vancouver.Router` instead of being defined in application config

  **Before (v0.1.x):**
  ```elixir
  # config/config.exs
  config :vancouver,
    tools: [MyApp.Tools.CalculateSum]
  ```

  **After (v0.2.0+):**
  ```elixir
  # router.ex
  forward "/mcp", Vancouver.Router, tools: [MyApp.Tools.CalculateSum]
  ```

### Added
- **Media Response Helpers**: New utilities for sending audio and image responses (#6)
- **Testing Support**: Introduction of `Vancouver.ToolTest` for easier tool testing (#7)

## [v0.1.1](https://github.com/your-repo/vancouver/releases/tag/v0.1.1) - 2025-05-30

### Added
- **Documentation**: Comprehensive documentation and guides (#3)
- **Phoenix Integration**: Streamlined integration with Phoenix router via `Vancouver.Router` (#4)
