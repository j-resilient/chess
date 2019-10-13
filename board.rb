require_relative 'piece'
class Board
    def [](pos)
        row, col = pos
        rows[row][col]
    end

    def []=(pos, val)
        rows[pos] = val
    end
    
    def initialize
        @rows = Array.new(8) { Array.new(8) }
    end
end