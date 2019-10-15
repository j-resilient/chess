require_relative 'cursor'

class HumanPlayer
    def initialize(color, display)
        @color = color
        @display = display
    end

    def make_move(board)
        pos = []
        until pos.length == 2
            @display.render
            input = @display.cursor.get_input
            pos << input if input.is_a?(Array)
        end
        board.move_piece(pos[0], pos[1])
    end
end