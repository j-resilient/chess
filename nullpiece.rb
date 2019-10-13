class NullPiece < Piece
    include Singleton

    attr_reader :symbol, :color

    def initialize
        @symbol = :Null
        @color = nil
    end
end