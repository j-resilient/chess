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
        # for later
    end

    def symbol
        raise NotImplementedError
    end
end