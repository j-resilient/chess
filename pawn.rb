require_relative 'piece'
require 'byebug'

class Pawn < Piece
    def symbol
        :Pawn
    end

    # I'm sure there's something I'm missing: the UML says this should be move_dirs
    # but every other class has a moves method via their module:
    # and they've got #move_dirs as a protected class to boot
    # so I'm calling this #moves for now
    def moves
        # returns all possible moves
        moves = []
        cur_row, cur_col = self.pos
        forward_steps.each do |dx, dy|
            new_move = [cur_row + dx, cur_col + dy]

            if new_move.all? { |coord| coord.between?(0,7) } && board[new_move].is_a?(NullPiece)
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
        return 1 if self.color == :Black
        return -1 if self.color == :White
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

        moves.delete_if { |move| board[move].is_a?(NullPiece) || board[move].color == self.color }
        moves
    end
end