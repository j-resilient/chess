require 'singleton'

class NullPiece < Piece
    include Singleton

    attr_reader :symbol, :color

    def initialize
        @symbol = :Null
        @color = :NoColor
    end

    def moves
        # placeholder
    end
end