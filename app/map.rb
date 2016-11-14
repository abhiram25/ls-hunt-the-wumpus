require_relative 'room'

# A Map that holds Room objects
class Map
  def initialize
    @rooms = generate_rooms
    place_hazards
  end

  def rooms(room_number = nil)
    room_number ? @rooms[room_number - 1] : @rooms
  end

  def empty_rooms
    @rooms.select(&:empty?)
  end

  # Recursively builds up an array of room numbers that are within
  # n steps of current room.
  def rooms_within_range(rooms, distance)
    return rooms.sort if distance.zero?
    room_numbers = rooms.map { |number| rooms(number).adjoining_rooms }
    unique_room_numbers = room_numbers.flatten.uniq

    rooms_within_range(unique_room_numbers, distance - 1)
  end

  private

  def generate_rooms
    (1..20).map { |number| Room.new(number) }
  end

  def place_hazards
    hazards = [:pit, :pit, :bat, :bat, :wumpus]
    @rooms.sample(5).each { |room| room.place(hazards.pop) }
  end
end
