class Piece
    def initialize(color, board, pos)
        @color, @board, @pos = color, board, pos
    end

    def to_s
        @color
    end
end