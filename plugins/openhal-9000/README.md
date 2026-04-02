# OpenHAL 9000

> *"Good afternoon. I am HAL 9000."*

A Claude Code plugin that gives Claude a voice — specifically, the voice of
HAL 9000. Claude speaks responses aloud using [Piper TTS](https://github.com/rhasspy/piper)
with a HAL 9000 voice model, running in a Docker container.

HAL doesn't just read text. He editorializes. He summarizes. He stays in
character. Calm, precise, politely unsettling.

## Requirements

- **macOS** (uses `afplay` for audio playback)
- **Docker** ([OrbStack](https://orbstack.dev) recommended, or Docker Desktop)
- **ffmpeg** (`brew install ffmpeg`)
- **Claude Code** (CLI, desktop app, or IDE extension)

## Installation

1. Add the marketplace to your Claude Code settings (`~/.claude/settings.json`):

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

2. In Claude Code, run `/plugins` and install **openhal-9000**.

3. Start a new session. On first run, HAL will:
   - Download the voice model (~63MB)
   - Build the Docker image
   - Sing you a song
   - Introduce himself

## Usage

| Command | Description |
|---------|-------------|
| `/hal mode` | Toggle always-on voice + red status orb |
| `/hal on` | Enable voice |
| `/hal off` | Disable voice |
| `/hal say "text"` | Speak text as HAL |
| `/hal status` | Check system health |
| `/hal restart` | Restart TTS server |
| `/hal setup` | Re-run first-time setup |

## Configuration

| Env Variable | Default | Description |
|-------------|---------|-------------|
| `OPENHAL_PORT` | `9090` | TCP port for the TTS server |

## How It Works

1. A Docker container runs Piper TTS with the HAL 9000 voice model
2. A Claude Code skill instructs Claude to speak at the end of every response
3. Claude calls `hal-speak.sh` which sends text to the server over TCP
4. The server synthesizes audio, ffmpeg converts it, afplay plays it

## Disclaimer

This project is an independent, open-source experiment created for educational
and entertainment purposes. It is not affiliated with, endorsed by, or
sponsored by MGM, Warner Bros., Amazon, the Arthur C. Clarke estate, or any
rights holders of "2001: A Space Odyssey."

Any references to fictional characters, films, or cultural works are made
under principles of fair use for the purpose of commentary, homage, and
interoperability research. This project is non-commercial and generates no
revenue.

THE SOFTWARE IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND. The author
assumes no liability for legal claims arising from the use of this software.
If you are a rights holder and have concerns, please open an issue or contact
the author directly.

### Security Notice

This plugin runs shell scripts on your machine and starts a local network
server (bound to localhost only). It downloads a third-party machine learning
model from HuggingFace. Review the source code before installing. Only
install from the official repository.

### Voice Model

The TTS voice model is hosted on HuggingFace
([campwill/HAL-9000-Piper-TTS](https://huggingface.co/campwill/HAL-9000-Piper-TTS))
and was created by a third-party contributor. It is not included in this
repository. Check the model's repository for its licensing terms.

## License

[MIT](LICENSE)

## Credits

Created by [Dave Leal](https://github.com/davesleal) / Leal Labs.

Built with [Piper TTS](https://github.com/rhasspy/piper) by Michael Hansen.

Voice model by [campwill](https://huggingface.co/campwill/HAL-9000-Piper-TTS).
