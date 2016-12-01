require_relative 'app/narrator'

game = WumpusGame.new
Narrator.new(game).play_game