# A Player that moves around Rooms in a Map
class Player
  attr_reader :current_room

  def initialize
    @arrows = 5
  end

  def move(room)
    @last_move = :move
    @current_room = room
  end

  def shoot
    @arrows -= 1
  end

  def adjoining_rooms
    current_room.adjoining_rooms
  end

  def out_of_arrows?
    @arrows.zero?
  end
end
