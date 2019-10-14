require_relative 'piece'
require_relative 'nullpiece'

module Slideable
    HORIZONTAL_DIRS = [[1,0],[0,1],[-1,0],[0,-1]]
    DIAGONAL_DIRS = [[1,1],[-1,-1],[1,-1],[-1,1]]

    def moves
        direction = []
        direction += HORIZONTAL_DIRS if self.move_dirs.include?(:horizontal)
        direction += DIAGONAL_DIRS if self.move_dirs.include?(:diagonal)

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
            if board[new_pos].empty?
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
        raise NotImplementedError
    end
end

class Rook < Piece
    include Slideable

    def symbol
        ' ♜ '.colorize(self.color)
    end

    protected
    def move_dirs
        [:horizontal]
    end
end

class Bishop < Piece
    include Slideable

    def symbol
        ' ♝ '.colorize(self.color)
    end

    protected
    def move_dirs
        [:diagonal]
    end
end

class Queen < Piece
    include Slideable

    def symbol
        ' ♛ '.colorize(self.color)
    end

    protected
    def move_dirs
        [:horizontal, :diagonal]
    end
end