require_relative 'piece'
require_relative 'slideable'
require_relative 'stepable'
require_relative 'nullpiece'
require_relative 'pawn'
require 'byebug'

class Board
    attr_accessor :rows

    def [](pos)
        row, col = pos
        rows[row][col]
    end

    def []=(pos, val)
        rows[pos] = val
    end

    def initialize
        @rows = Array.new(8) { Array.new(8) }
        pieces
    end

    def pieces
        place_pawns(1, :Black)
        place_pawns(6, :White)
        place_court(0, :Black)
        place_court(7, :White)
        place_null_pieces
    end

    def place_pawns(row, color)
        rows[row].each_with_index do |square, col_idx| 
            new_pawn = Pawn.new(color, self, [row, col_idx])
            add_piece(new_pawn, new_pawn.pos) 
        end
    end

    def place_court(row, color)
        court = get_court(color)
        rows[row].each_with_index do |square, col_idx| 
            piece = court[col_idx]
            piece.pos = [row, col_idx]
            add_piece(piece, piece.pos)
        end
    end

    def get_court(color)
        court = [
            Rook.new(color, self, nil),
            Knight.new(color, self, nil),
            Bishop.new(color, self, nil),
            King.new(color, self, nil),
            Queen.new(color, self, nil),
            Bishop.new(color, self, nil),
            Knight.new(color, self, nil),
            Rook.new(color, self, nil)
        ]
    end

    def place_null_pieces
        rows.each_with_index do |row, row_idx|
            row.each_with_index do |square, col_idx|
                rows[row_idx][col_idx] = NullPiece.instance if square.nil?
            end
        end
    end

    def add_piece(piece, pos)
        row, col = pos
        rows[row][col] = piece
    end

    # def pretty_print_board
    #     print "  "
    #     (0..7).each { |i| print "    #{i}   " }
    #     puts
    #     rows.each_with_index do |row, r_idx| 
    #         print "#{r_idx}  "
    #         row.each do |square| 
    #             print square.to_s unless square.is_a?(NullPiece)
    #             print "  " if square.is_a?(Pawn) || square.is_a?(Rook) || square.is_a?(King)
    #             print " " if square.is_a?(Queen)
    #             print "______" if square.is_a?(NullPiece)
    #             print "  "
    #         end
    #         puts
    #     end
    #     print "\n\n\n"
    # end

    def move_piece(start_pos, end_pos)
        start_row, start_col = start_pos
        end_row, end_col = end_pos
        piece = rows[start_row][start_col]

        raise "There is no piece at #{start_pos}." if rows[start_row][start_col].is_a?(NullPiece)
        raise "Cannot move pieces off of board." unless valid_pos?(end_pos) && valid_pos?(start_pos)
        raise "Piece cannot move there." unless rows[start_row][start_col].moves.include?(end_pos)

        piece.pos = end_pos
        rows[end_row][end_col], rows[start_row][start_col] = rows[start_row][start_col], NullPiece.instance
    end

    def valid_pos?(pos)
        pos.all? { |n| n.between?(0,7) }
    end
end
x = Board.new
# # Pawns
# x.move_piece([1,7], [3,7])
# x.move_piece([6,6], [4,6])
# x.move_piece([3,7], [4,6])
# x.move_piece([6,7], [4,7])
# x.move_piece([6,0], [4,0])

# # Rooks
# x.move_piece([7,7], [5,7])
# x.move_piece([7,0], [5,0])
# x.move_piece([5,7], [5,4])
# x.move_piece([5,4], [1,4])

# # Knights
# x.move_piece([0,6], [1,4])
# x.move_piece([1,4], [3,3])

# # Bishops
# x.move_piece([0,5], [3,2])
# x.move_piece([3,2], [6,5])

# # King
# x.move_piece([0,3], [1,4])
# x.move_piece([1,4], [2,4])

# # Queen
# x.move_piece([0,4], [1,4])
# x.move_piece([1,4], [4,7])
# x.move_piece([4,7], [7,7])
# x.move_piece([7,7], [7,6])
# x.move_piece([7,6], [7,5])