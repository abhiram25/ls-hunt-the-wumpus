require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative '../app/player'
require_relative '../app/room'

class PlayerTest < Minitest::Test
  def setup
    @player = Player.new
    @room = Room.new(1)
  end

  def test_move_changes_player_current_room
    @player.move(@room)
    assert_equal 1, @player.current_room.number

    next_room = Room.new(2)
    @player.move(next_room)
    assert_equal 2, @player.current_room.number
  end

  def test_player_only_has_five_shots
    5.times { @player.shoot }
    assert @player.out_of_arrows?
  end

  def test_player_cant_shoot_two_consecutive_moves
    @player.shoot
    refute @player.can_shoot?
  end
end