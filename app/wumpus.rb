require_relative 'map'
require_relative 'player'
require_relative 'utilities'

class WumpusGame
  include Utilities

  attr_reader :player, :wumpus, :map

  def initialize
    @map = Map.new
    @player = Player.new
    @wumpus = nil
    place_player
  end

  def place_player
    starting_room = @map.empty_rooms.sample
    @player.move(starting_room)
  end

  def start
    fancy_output 'Welcome to Hunt the Wumpus!'
    enter_to_continue
    nearby_room_messages
    loop do
      display_current_room
      choice = player_choice
      move_or_shoot(choice)
      display_move_outcome if choice == 'm'
      update_result
      break if game_over?
      nearby_room_messages
    end
    fancy_output final_result if final_result
    fancy_output 'Thanks for Playing Hunt the Wumpus. Goodbye!'
  end

  private

  def player_choice
    if player.can_shoot?
      message = 'What would you like to do? (s)hoot or (m)ove:'
      get_input(message, choices: ['m', 's'])
    else
      'm'
    end
  end

  def move_or_shoot(choice)
    choice == 'm' ? player_move : player_shoot
  end

  def player_move
    room_choices = adjoining_rooms.map(&:to_s)
    message = "Pick a room to move to: #{room_choices.join(', ')}"
    room_number = get_input(message, choices: room_choices, number: true)
    room = map.rooms(room_number)
    player.move(room)
  end

  def player_shoot
    distance = choose_shot_distance
    room_number = draw_arrow_path(distance)
    room = map.rooms(room_number)
    player.shoot
    result_of_shot = room.incoming_arrow
    @wumpus = :dead if result_of_shot == :hit
    animate('>>>--------~>')
  end

  def display_move_outcome
    fancy_output player.current_room.move_outcome[:message]
  end

  def update_result
    outcome = player.current_room.move_outcome
    
    if outcome[:result] == :dead
      player.kill
    elsif outcome[:result] == :carried
      new_room = @map.rooms(rand(1..20))
      player.move(new_room)
      display_move_outcome
      update_result
    end
  end

  def nearby_room_messages
    messages = adjoining_rooms.map(&:message)
    unique = messages.compact.uniq
    unique.each { |message| fancy_output message }
  end

  def game_over?
    player.dead? || player.out_of_arrows? || wumpus == :dead
  end

  def final_result
    if player.out_of_arrows?
      'You ran out of arrows and lost the game.'
    elsif wumpus == :dead
      'You killed the Wumpus and won the game.'
    end
  end

  def display_current_room
    fancy_output "You are currently in room #{player.current_room}"
  end

  def adjoining_rooms(room_number = nil)
    if room_number
      rooms = @map.rooms(room_number).adjoining_rooms
      rooms.map { |num| @map.rooms(num) }
    else
      player.adjoining_rooms.map { |num| @map.rooms(num) }
    end
  end

  def draw_arrow_path(distance)
    room_number = player.current_room.number
    distance.times do
      room_choices = adjoining_rooms(room_number).map(&:to_s)
      message = "Draw your arrow path by selecting a room: #{room_choices.join(', ')}"
      choice = get_input(message, choices: room_choices, number: true)
      room_number = choice
    end
    room_number
  end

  def choose_shot_distance
    message = 'Choose a shot distance in number of rooms from 1-5'
    choices = [1, 2, 3, 4, 5].map(&:to_s)
    get_input(message, choices: choices, number: true)
  end
end
