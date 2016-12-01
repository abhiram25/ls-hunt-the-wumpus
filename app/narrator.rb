require "yaml"
require_relative 'wumpus'
require 'pry'
class Narrator
  include Utilities
  
  def initialize(game)
    @game = game
    @output = YAML.load_file("data/output.yaml")
    @actions = YAML.load_file("data/actions.yaml")
  end

  def play_game 
    loop do
      next if output?
      game_state = @game.state
      post_invalid if invalid_input?
      message = @output[game_state]
      options = parse_options(@game.input_options)
      post_output(message, options)
      break if @game.over?
      action = @actions[game_state]
      input = nil
      input = get_input if input_required? || invalid_input?
      @game.io_state = :output
      @game.send(action, input)
    end
  end

  def get_input
    input = gets.chomp
    clear_screen
    input
  end

  def parse_options(options)
    options.join(' - ')
  end

  def post_output(message, options=nil)
    puts message + "#{options}"
  end

  def post_invalid
    message = @output[:invalid_input]
    post_output(message)
  end

  def output?
    @game.io_state == :output
  end

  def input_required?
    @game.io_state == :input_required
  end

  def invalid_input?
    @game.io_state == :invalid_input
  end
end
