require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative '../app/room'

class RoomTest < Minitest::Test
  def setup
    @room = Room.new(1)
  end

  def test_adjoining_rooms_are_properly_set_on_initialization
    assert_equal [2, 5, 8], @room.adjoining_rooms
  end

  def test_place_method_properly_sets_room_hazard
    @room.place(:bat)
    assert_equal :bat, @room.hazard
  end

  def test_room_returns_correct_nearby_message
    @room.place(:bat)
    assert_equal 'Bats nearby!', @room.nearby_message

    @room.place(:pit)
    assert_equal 'I feel a draft!', @room.nearby_message

    @room.place(:wumpus)
    assert_equal 'I smell a Wumpus!', @room.nearby_message
  end

  def test_room_returns_correct_result_of_entering
    assert_equal :safe_room, @room.result_of_entering

    @room.place(:bat)
    assert_equal :carried_by_bats, @room.result_of_entering

    @room.place(:pit)
    assert_equal :fell_into_pit, @room.result_of_entering

    @room.place(:wumpus)
    assert_equal :killed_by_wumpus, @room.result_of_entering
  end

  def test_empty_method_returns_correct_boolean
    assert @room.empty?
    @room.place(:bat)
    refute @room.empty?
  end
end