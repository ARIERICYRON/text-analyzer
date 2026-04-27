class AnalyzeController < ApplicationController
  def create
    text = params[:text].to_s.strip
    return render json: { error: "Text input cannot be empty." }, status: :bad_request if text.empty?

    result = TextAnalyzerService.new(text).call
    render json: result
  rescue TextAnalyzerService::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
