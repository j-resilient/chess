class Piece
    attr_reader :color, :board
    attr_accessor :pos
    def initialize(color, board, pos)
        @color, @board, @pos = color, board, pos
    end

    def to_s
        self.symbol
    end

    def empty?
        false
    end

    def valid_moves
        moves = self.moves
        moves.delete_if { |move| move_into_check?(move) }
        moves
    end

    def move_into_check?(end_pos)
        dup_board = board.dup
        dup_board.move_piece!(self.pos, end_pos)
        dup_board.in_check?(self.color)
    end

    def symbol
        raise NotImplementedError
    end
end