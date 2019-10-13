class Piece
    attr_accessor :pos, :board, :color
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
        # ??? not overwritten by a subclass I got nothing
    end

    def symbol
        # overwritten by a subclass
        @color
    end
end