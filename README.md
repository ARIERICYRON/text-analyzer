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
