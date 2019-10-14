require 'singleton'

class NullPiece < Piece
    include Singleton

    attr_reader :symbol, :color

    def initialize
        @symbol = "   "
        @color = :NoColor
    end

    def empty?
        true
    end

    def moves
        []
    end
end