require_relative 'piece'
require_relative 'slideable'
require_relative 'stepable'
require_relative 'nullpiece'
require_relative 'pawn'
require 'colorize'

class Board
    attr_accessor :rows

    def [](pos)
        row, col = pos
        rows[row][col]
    end

    def []=(pos, val)
        row, col = pos
        rows[row][col] = val
    end

    def empty?(pos)
        self[pos].empty?
    end

    def initialize
        @rows = Array.new(8) { Array.new(8) }
        fill_board
    end

    def add_piece(piece, pos)
        row, col = pos
        rows[row][col] = piece
    end

    def pretty_print_board
        print "   "
        (0..7).each { |i| print " #{i} " }
        puts
        rows.each_with_index do |row, r_idx| 
            print "#{r_idx}  "
            row.each do |square|
                print square.to_s
            end
            puts
        end
        print "\n\n"
    end

    def move_piece(start_pos, end_pos)
        # so basically all validity checking goes here
        #but the actual moving goes in #move_piece!
        piece = self[start_pos]

        raise "There is no piece at #{start_pos}." if self.empty?(start_pos)
        raise "Cannot move pieces off of board." unless valid_pos?(end_pos) && valid_pos?(start_pos)
        raise "Piece cannot move there." unless piece.moves.include?(end_pos)

        move_piece!(start_pos, end_pos)
        pretty_print_board
    end

    def move_piece!(start_pos, end_pos)
        piece = self[start_pos]

        piece.pos = end_pos
        self[end_pos] = piece
        self[start_pos] = NullPiece.instance
    end

    def valid_pos?(pos)
        pos.all? { |n| n.between?(0,7) }
    end

    private
    def fill_board
        place_pawns(1, :Black)
        place_pawns(6, :White)
        place_court(0, :Black)
        place_court(7, :White)
        place_null_pieces
        pretty_print_board
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
end
x = Board.new
# Pawns
x.move_piece([1,7], [3,7])
x.move_piece([6,6], [4,6])
x.move_piece([3,7], [4,6])
x.move_piece([6,7], [4,7])
x.move_piece([6,0], [4,0])

# Rooks
x.move_piece([7,7], [5,7])
x.move_piece([7,0], [5,0])
x.move_piece([5,7], [5,4])
x.move_piece([5,4], [1,4])

# Knights
x.move_piece([0,6], [1,4])
x.move_piece([1,4], [3,3])

# Bishops
x.move_piece([0,5], [3,2])
x.move_piece([3,2], [6,5])

# King
x.move_piece([0,3], [1,4])
x.move_piece([1,4], [2,4])

# Queen
x.move_piece([0,4], [1,4])
x.move_piece([1,4], [4,7])
x.move_piece([4,7], [7,7])
x.move_piece([7,7], [7,6])
x.move_piece([7,6], [7,5])