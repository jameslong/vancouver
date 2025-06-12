# Changelog

## v0.2.0 (2025-06-12)

### Breaking changes

- Tools must now be passed as an option to `Vancouver.Router` rather than defined in the config

i.e. 

```elixir
# v0.1.1
config :vancouver,
  ...
  tools: [MyApp.Tools.CalculateSum]

# v0.2.0
forward "/mcp", Vancouver.Router, tools: [MyApp.Tools.CalculateSum]
```

### Features
- helpers to send audio/image responses (#6)
- `Vancouver.ToolTest` (#7)


## v0.1.1 (2025-05-30)

### Added
- docs! (#3)
- easier integration with Phoenix router via `Vancouver.Router` (#4)