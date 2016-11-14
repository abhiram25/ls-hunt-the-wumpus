require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative '../app/game'

class GameTest < Minitest::Test
  def setup
    @game = Game.new
    @player = @game.player
    @map = @game.map
  end

  def test_proper_game_state_after_player_move
    @game.move_player(empty_room)
    assert_equal :safe_room, @game.state

    @game.move_player(bat_room)
    @game.move_player(wumpus_room)
    assert_equal [:carried_by_bats, :killed_by_wumpus], @game.state
  
    @game.move_player(pit_room)
    assert_equal :fell_into_pit, @game.state
    assert @game.over?

    @game.move_player(wumpus_room)
    assert_equal :killed_by_wumpus, @game.state
    assert @game.over?
  end

  def test_proper_game_state_when_player_runs_out_of_arrows
    5.times { @game.shoot_arrow(empty_room) }
    assert_equal :out_of_arrows, @game.state
    assert @game.over?
  end

  def test_proper_game_state_when_player_kills_wumpus
    @game.shoot_arrow(wumpus_room)
    assert_equal :killed_wumpus, @game.state
    assert @game.over?
  end

  private

  # Some test helpers
  def empty_room
    @map.empty_rooms.sample.number
  end

  def wumpus_room
    @map.rooms.find { |r| r.hazard == :wumpus }.number
  end

  def bat_room
    @map.rooms.find { |r| r.hazard == :bat }.number
  end

  def pit_room
    @map.rooms.find { |r| r.hazard == :pit }.number
  end
end