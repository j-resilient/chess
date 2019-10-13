class Piece
    attr_accessor :pos, :board, :color
    def initialize(color, board, pos)
        @color, @board, @pos = color, board, pos
    end

    def to_s
        @color
    end

    def empty?
        false
    end

    def valid_moves
        # just a placeholder? all of the pieces move differently
    end

    def symbol
        # another placeholder??
    end
end