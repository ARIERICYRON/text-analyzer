class TextAnalyzerService
  Error = Class.new(StandardError)

  SYSTEM_PROMPT = <<~PROMPT
    You are a helpful assistant that analyzes text.
    Given a block of text, return a JSON object with exactly two fields:
    - "summary": a concise 2-3 sentence summary of the text
    - "action_items": an array of exactly 3 actionable next steps derived from the text

    Respond ONLY with valid JSON. No markdown, no explanation.
  PROMPT

  def initialize(text)
    @text = text
    @client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
  end

  def call
    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          { role: "user",   content: @text }
        ],
        response_format: { type: "json_object" },
        temperature: 0.3
      }
    )

    raw = response.dig("choices", 0, "message", "content")
    result = JSON.parse(raw)

    unless result.key?("summary") && result.key?("action_items")
      raise Error, "Unexpected response format from AI."
    end

    {
      summary: result["summary"],
      action_items: result["action_items"].first(3)
    }
  rescue JSON::ParserError
    raise Error, "Failed to parse AI response as JSON."
  end
end
