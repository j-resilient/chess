require_relative 'board'
require_relative 'display'
require_relative 'human'

class Game
    def initialize
        @board = Board.new
        @display = Display.new(board)
        @players = { 
            :white => HumanPlayer.new(:white, @display), 
            :black => HumanPlayer.new(:black, @display) 
        }
        @current_player = @players[:white]
    end

    def play
        until game_over?
            display.render
            begin
                @current_player.make_move(board)
            rescue => exception
                notify_players(exception)
            end
            swap_turn!
        end
        print_winner
    end

    def game_over?
        board.checkmate?(:white) || board.checkmate?(:black)
    end

    def print_winner
        winner = board.checkmate?(:white) ? "Black" : "White"
        puts "#{winner} wins!"
    end

    def swap_turn!
        @current_player = (@current_player == @players[:white]) ? @players[:black] : @players[:white]
    end

    def notify_players(exception)
        puts exception
        sleep(2)
    end

    private
    attr_reader :board, :display, :players, :current_player
end

game = Game.new
game.play