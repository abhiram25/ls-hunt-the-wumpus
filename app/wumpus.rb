require_relative 'map'
require_relative 'player'
require_relative 'utilities'

class WumpusGame
  include Utilities

  attr_accessor :io_state
  attr_reader :state, :input_options, :player, :wumpus, :map

  def initialize
    @io_state = :input_required
    @state = :new_game
    @input_options = []
    @map = Map.new
    @player = Player.new
    @wumpus = nil
    place_player
  end

  def place_player
    starting_room = @map.empty_rooms.sample
    @player.move(starting_room)
  end

  def player_choice(input=nil)
    @state = :player_choice
    @input_options = ['m', 's']
    @io_state = :input_required
  end

  def process_player_choice(input=nil)
    case input.downcase
    when 's'
      player_choice_shoot
    when 'm'
      player_choice_move
    else
      invalid_input
    end
  end

  def player_choice_move(input=nil)
    @state = :pick_room
    @input_options = adjoining_rooms.map { |room| room.number }
    @io_state = :input_required
  end

  def process_room_choice(room_choice)
    room_number = room_choice.to_i
    if @input_options.include?(room_number)
      room = map.rooms(room_number)
      player.move(room)
      process_move_outcome
    else
      invalid_input
    end
  end

  def process_move_outcome
    hazard = player.current_room.hazard
    if hazard
      @state = hazard
    else
      @state = :safe
    end
    @input_options = []
    @io_state = :input_not_required
  end

  def room_messages(input = nil)
    @state = :room_messages
    current_room = player.current_room
    @input_options = [current_room].concat(nearby_room_messages)
    @io_state = :input_not_required
  end

  def nearby_room_messages
    messages = adjoining_rooms.map(&:message)
    messages.compact.uniq
  end

  def carry_player(input = nil)
    new_room = @map.rooms(rand(1..20))
    player.move(new_room)
    process_move_outcome
  end

  def player_choice_shoot
    @state = :pick_target_room
    @input_options = adjoining_rooms.map { |room| room.number }
    @io_state = :input_required
  end

  def fire_arrow(target_room)
    room_number = target_room.to_i
    if @input_options.include?(room_number)
      room = map.rooms(room_number)
      player.shoot
      result_of_shot = room.incoming_arrow
      process_shot_result(result_of_shot)
    else
      invalid_input
    end
  end

  def process_shot_result(result_of_shot)
    if result_of_shot == :hit
      @state = :wumpus_killed
    elsif @player.out_of_arrows?
      @state = :out_of_arrows
    else
      @state = :shot_missed
    end
    @input_options = []
    @io_state = :input_not_required
  end

  def invalid_input
    @io_state = :invalid_input
  end

  def end_game(input = nil)
    @state = :game_over
    @input_options = []
    @io_state = :input_not_required
  end

  def over?
    @state == :game_over
  end

  def adjoining_rooms(room_number = nil)
    if room_number
      rooms = @map.rooms(room_number).adjoining_rooms
      rooms.map { |num| @map.rooms(num) }
    else
      player.adjoining_rooms.map { |num| @map.rooms(num) }
    end
  end
end