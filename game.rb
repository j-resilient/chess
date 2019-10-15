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
        @current_player = :white
    end

    def play
        until game_over?
            display.cursor.cursor_pos = current_player == :black ? [0,0] : [7,0]
            display.render
            begin
                @players[current_player].make_move(board)
                swap_turn!
                notify_players
            rescue => exception
                puts exception
                sleep(2)
            end
        end
        print_winner
    end

    def game_over?
        board.checkmate?(current_player)
    end

    def print_winner
        winner = board.checkmate?(:white) ? "Black" : "White"
        puts "#{winner} wins!"
    end

    def swap_turn!
        @current_player = (@current_player == :white) ? :black : :white
    end

    def notify_players
        if board.in_check?(@current_player)
            display.check 
        else
            display.uncheck
        end
    end

    private
    attr_reader :board, :display, :players, :current_player
end

if $PROGRAM_NAME == __FILE__
  Game.new.play
end