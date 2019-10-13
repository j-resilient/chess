require_relative 'piece'

module Slideable
    HORIZONTAL_DIRS = [[1,0],[0,1],[-1,0],[0,-1]]
    DIAGONAL_DIRS = [[1,1],[-1,-1],[1,-1],[-1,1]]
    
    def set_horizontal_dirs
        digits = (-6...0).to_a + (1..6).to_a
        digits.map { |d| [d, 0] } + digits.map { |d| [0, d] }
    end

    def moves
        # returns all possible moves
        direction = self.move_dirs == :horizontal ? HORIZONTAL_DIRS : DIAGONAL_DIRS
        moves = []
        direction.each do |dx, dy|
            moves += grow_unblocked_moves_in_dir(dx, dy)
        end
        moves
    end

    private
    def grow_unblocked_moves_in_dir(dx, dy)
        cur_row, cur_col = self.pos
        moves = []
        new_pos = []
        while (cur_row + dx).between?(0,7) && (cur_col + dy).between?(0,7)
            new_pos = [cur_row + dx, cur_col + dy]
            if board[new_pos].nil?
                moves << new_pos
                cur_row, cur_col = new_pos
            else
                moves << new_pos if board[new_pos].color != self.color
                break
            end
        end
        moves
    end

    def move_dirs
        #overwritten in subclass
    end
end

class Rook < Piece
    include Slideable

    def symbol
        :Rook
    end

    protected
    def move_dirs
        :horizontal
    end
end

class Bishop < Piece
    include Slideable

    def symbol
        :Bishop
    end

    def move_dirs
        :diagonal
    end
end