# frozen_string_literal: true

class RecipeGeneratorService
  attr_reader :message, :user

  OPENAI_TEMPERATURE = ENV.fetch('OPENAI_TEMPERATURE', 0).to_f
  OPENAI_MODEL = ENV.fetch('OPENAI_MODEL', 'gpt-4')

  def initialize(message, user_id)
    @message = message
    @user = User.find(user_id)
  end

  def call
    check_valid_message_length
    response = message_to_chat_api
    create_recipe(response)
  end

  private

  def check_valid_message_length
    error_msg = I18n.t('api.errors.invalid_message_length')
    raise RecipeGeneratorServiceError, error_msg unless message.present?
  end

  def message_to_chat_api
    openai_client.chat(parameters: {
                         model: OPENAI_MODEL,
                         messages: request_messages,
                         temperature: OPENAI_TEMPERATURE
                       })
  end

  def request_messages
    system_message + new_message
  end

  def system_message
    [{ role: 'system', content: prompt }]
  end

  def prompt
    "Generate a recipe using the following ingredients: #{message}"
  end

  def new_message
    [{ role: 'user', content: "Ingredients: #{message}" }]
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def create_recipe(response)
    # La respuesta es siempre un texto en formato de receta
    content = parse_recipe_text(response.dig('choices', 0, 'message', 'content'))
    { 'name' => content[:name], 'content' => content[:instructions] }
  rescue JSON::ParserError => exception
    raise RecipeGeneratorServiceError, "Failed to parse recipe: #{exception.message}"
  end

  def parse_recipe_text(text)
    # Extrae el nombre de la receta y las instrucciones
    name = text.match(/^Recipe:\s*(.*)$/)&.captures&.first || 'Generated Recipe'
    instructions = text.split("\n").drop(1).join("\n").strip
    { name: name, instructions: instructions }
  end
end