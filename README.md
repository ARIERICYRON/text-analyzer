# Text Analyzer API

A Rails API that takes a block of text and uses OpenAI to return a structured summary and 3 key action items.

## Setup

```bash
bundle install
cp .env.example .env   # add your OpenAI API key
rails server
```

## Usage

```bash
curl -X POST http://localhost:3000/analyze \
  -H "Content-Type: application/json" \
  -d '{"text": "Your block of text goes here..."}'
```

## Response

```json
{
  "summary": "A concise 2-3 sentence summary.",
  "action_items": [
    "First action item",
    "Second action item",
    "Third action item"
  ]
}
```

## Structure

- `app/controllers/analyze_controller.rb` — handles the request/response
- `app/services/text_analyzer_service.rb` — encapsulates OpenAI logic
- `config/routes.rb` — single route: `POST /analyze`

## Notes

- Model: `gpt-4o-mini` (fast and cost-effective)
- `temperature: 0.3` keeps output focused and consistent
- `response_format: json_object` enforces valid JSON from the model

## What didn't work at first and how I adjusted

- Started with Python/FastAPI, then switched to Sinatra, then to Rails — iterated based on preference rather than assuming upfront
- `rails new` used `--skip-git` for speed, which meant no `.gitignore` was generated — caught this before pushing and created one manually, ensuring `.env` was excluded and `.env.example` was kept
- `bundle install` timed out during scaffolding on Windows — the gems were still resolving in the background, so the app structure was intact and the install completes fine when run manually
- `git push` couldn't be run automatically because GitHub authentication requires interactive input (username + token) — has to be done manually in the terminal
- Line ending warnings (LF → CRLF) showed up on `git add` due to Windows — added a `.gitattributes` file with `* text=auto` to normalize this going forward

## What I would improve with more time

- Add RSpec tests with a stubbed OpenAI client so the suite runs without a real API key
- Add request rate limiting to avoid abuse
- Extract the model name and temperature into environment variables so they're configurable without touching code
- Add a simple retry mechanism for transient OpenAI API failures
