# Leal Labs — Claude Code Plugins

Plugins for Claude Code by [Leal Labs](https://github.com/davesleal).

## Plugins

| Plugin | Description |
|--------|-------------|
| [OpenHAL 9000](plugins/openhal-9000/) | HAL 9000 voice for Claude Code |

## Installation

Add to `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "leal-labs": {
      "source": {
        "source": "github",
        "repo": "davesleal/claude-plugins"
      }
    }
  }
}
```

Then install via `/plugins` in Claude Code.
