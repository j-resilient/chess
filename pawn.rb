require_relative 'piece'
require 'byebug'

class Pawn < Piece
    def symbol
        ' ♟ '.colorize(color)
    end

    def moves
        moves = []
        cur_row, cur_col = self.pos
        forward_steps.each do |dx, dy|
            new_move = [cur_row + dx, cur_col + dy]

            if new_move.all? { |coord| coord.between?(0,7) } && board[new_move].empty?
                moves << new_move
            end
        end
        moves + side_attacks
    end

    private

    def at_start_row?
        (self.pos[0] == 1 && self.color == :Black) ||
            (self.pos[0] == 6 && self.color == :White)
    end

    def forward_dir
        color == :Black ? 1 : -1
    end

    def forward_steps
        steps = [[forward_dir, 0]]
        steps << [forward_dir * 2, 0] if at_start_row?
        steps
    end

    def side_attacks
        cur_row, cur_col = self.pos
        forward = cur_row + forward_dir
        moves = []
        
        if forward.between?(0,7)
            moves << [forward, cur_col - 1] if (cur_col - 1).between?(0,7)
            moves << [forward, cur_col + 1] if (cur_col + 1).between?(0,7)
        end

        moves.delete_if { |move| board[move].empty? || board[move].color == self.color }
        moves
    end
end