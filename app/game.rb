# game.rb

require_relative 'map'
require_relative 'player'

# List of possible game states:
# :new_game, :out_of_arrows, :killed_by_wumpus, :killed_wumpus,
# :missed_wumpus, :safe_room, :carried_by_bats, :fell_into_pit
class Game
  attr_reader :player, :map, :state

  def initialize
    @map = Map.new
    @player = Player.new
    @state = :new_game

    place_player
  end

  # Moves player to random room if room_number argument is nil
  # Otherwise moves to the specified room.
  def move_player(room_number = nil)
    room = [map.rooms(room_number)].flatten.sample
    player.move(room)
    outcome = player_current_room.result_of_entering
    @state = carried_by_bats? ? [:carried_by_bats, outcome] : outcome
  end

  def shoot_arrow(room_number)
    player.shoot
    hazard = map.rooms(room_number).hazard
    @state = result_of_shot(hazard)
  end

  def over?
    game_ending_states = [:killed_wumpus, :out_of_arrows,
                          :fell_into_pit, :killed_by_wumpus]
    game_ending_states.include?(state)
  end

  # A couple wrappers so calling objects don't have to chain method calls
  def player_current_room
    player.current_room
  end

  def player_can_shoot?
    player.can_shoot?
  end

  # Methods for getting information about surrounding rooms
  def adjoining_rooms(room_number = nil)
    if room_number
      rooms = @map.rooms(room_number).adjoining_rooms
      rooms.map { |num| @map.rooms(num) }
    else
      player.adjoining_rooms.map { |num| @map.rooms(num) }
    end
  end

  def rooms_within_range(distance)
    room_number = player_current_room.number
    within_range = map.rooms_within_range([room_number], distance)
    within_range.map(&:to_s)
  end

  def nearby_room_messages
    messages = adjoining_rooms.map(&:nearby_message)
    messages.compact.uniq
  end

  def carried_by_bats?
    state == :carried_by_bats
  end

  private

  def result_of_shot(hazard)
    return :killed_wumpus if hazard == :wumpus

    if player.out_of_arrows?
      :out_of_arrows
    else
      :missed_wumpus
    end
  end

  def place_player
    starting_room = @map.empty_rooms.sample
    @player.move(starting_room)
  end
end
