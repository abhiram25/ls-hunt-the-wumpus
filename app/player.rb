# A Player that moves around Rooms in a Map
class Player
  attr_reader :current_room

  def initialize
    @arrows = 5
    @dead = false
    @last_move = nil
  end

  def move(room)
    @last_move = :move
    @current_room = room
  end

  def shoot
    @last_move = :shot
    @arrows -= 1
  end

  def adjoining_rooms
    current_room.adjoining_rooms
  end

  def kill
    @dead = true
  end

  def dead?
    @dead
  end

  def out_of_arrows?
    @arrows.zero?
  end

  def can_shoot?
    @last_move != :shot
  end
end
