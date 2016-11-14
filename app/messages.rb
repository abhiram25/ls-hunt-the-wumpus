# messages.rb
require 'yaml'

# Overwrites method_missing to catch message related method calls and
# either return or display the appropriate message from the messages.yaml file.
# Example Uses:
# => welcome_message: Returns "Welcome to Hunt the Wumpus!"
# => display_welcome_message: Outputs "Welcome to Hunt the Wumpus!", returns nil
module Messages
  MESSAGES = YAML.load_file('messages.yaml')

  def method_missing(symbol, *args)
    method_name = parse_method_name(symbol)
    rest_of_message = args.first || ''
    message = MESSAGES[method_name]

    if message
      return_or_display(symbol, message, rest_of_message)
    else
      super
    end
  end

  def respond_to_missing?(symbol, include_private = false)
    method_name = parse_method_name(symbol)
    MESSAGES[method_name] || super
  end

  private

  def parse_method_name(symbol)
    symbol.to_s.gsub(/(_message|display_)/, '')
  end

  def return_or_display(symbol, message, rest_of_message)
    message = "#{message} #{rest_of_message}"
    if symbol.to_s =~ /display/
      puts message
    else
      message
    end
  end
end
