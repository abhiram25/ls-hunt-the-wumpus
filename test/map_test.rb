require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative '../app/map'

class MapTest < Minitest::Test
  def setup
    @map = Map.new
  end

  def test_map_has_20_rooms
    assert_equal 20, @map.rooms.size
  end

  def test_map_has_15_empty_rooms
    assert_equal 15, @map.empty_rooms.size
  end

  def test_map_has_2_pits
    pit_rooms = @map.rooms.select { |room| room.hazard == :pit }
    assert_equal 2, pit_rooms.size
  end

  def test_map_has_2_bats
    bat_rooms = @map.rooms.select { |room| room.hazard == :bat }
    assert_equal 2, bat_rooms.size
  end

  def test_map_has_1_wumpus
    wumpus_room = @map.rooms.select { |room| room.hazard == :wumpus }
    assert_equal 1, wumpus_room.size
  end

  def test_all_rooms_have_correct_adjoining_rooms
    actual_rooms = (1..20).map do |room|
      @map.rooms(room).adjoining_rooms
    end

    expected_rooms = [
      [2, 5, 8], [1, 3, 10], [2, 4, 12], [3, 5, 14],
      [1, 4, 6], [5, 7, 15], [6, 8, 17], [1, 7, 11],
      [10, 12, 19], [2, 9, 11], [8, 10, 20], [3, 9, 13],
      [12, 14, 18], [4, 13, 15], [6, 14, 16], [15, 17, 18],
      [7, 16, 20], [13, 16, 19], [9, 18, 20], [11, 17, 19]
    ]

    assert_equal expected_rooms, actual_rooms
  end
end  