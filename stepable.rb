require_relative 'piece'

module Stepable
    def moves
        moves = []
        cur_row, cur_col = self.pos
        self.move_diffs.each do |dx, dy|
            new_pos = [cur_row + dx, cur_col + dy]
            if board[new_pos].nil? || board[new_pos].color != self.color
                moves << new_pos
            end
        end
        moves
    end

    private
    def move_diffs
        # overwritten by subclasses
    end
end

class Knight < Piece
    include Stepable 

    def symbol
        :Knight
    end

    protected
    def move_diffs
        [[-2, -1], [-2,  1], [-1, -2], [-1,  2], 
        [ 1, -2],[ 1,  2], [ 2, -1],[ 2,  1]]
    end
end

class King < Piece
    include Stepable 

    def symbol
        :King
    end

    protected
    def move_diffs
        [[-1,-1],[0,-1],[1,-1], [-1,0], [1,0], [-1,1], [0,1], [1,1]]
    end
end