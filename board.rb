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
        (0..1).each do |row_idx|
            (0...rows.length).each do |col_idx|
                new_piece = Piece.new(:Black, self, [row_idx, col_idx])
                add_piece(new_piece, [row_idx, col_idx])
            end
        end

        (2..5).each do |row_idx|
            (0...rows.length).each do |col_idx|
                add_piece(NullPiece.instance, [row_idx, col_idx])
            end
        end
        
        (6..7).each do |row_idx|
            (0...rows.length).each do |col_idx|
                new_piece = Piece.new(:White, self, [row_idx, col_idx])
                add_piece(new_piece, [row_idx, col_idx])
            end
        end
        pawn = Pawn.new(:Black, self, [1,7])
        add_piece(pawn, pawn.pos)
        # print "Black Pawn: #{pawn.moves}\n"

        pawn = Pawn.new(:White, self, [4,6])
        add_piece(pawn, pawn.pos)
        # print "White Pawn: #{pawn.moves}\n"

        pretty_print_board
    end

    def add_piece(piece, pos)
        row, col = pos
        rows[row][col] = piece
    end

    def pretty_print_board
        print "  "
        (0..7).each { |i| print "   #{i}   " }
        puts
        rows.each_with_index do |row, r_idx| 
            print "#{r_idx}  "
            row.each do |square| 
                print square.to_s unless square.is_a?(NullPiece)
                print "_____" if square.is_a?(NullPiece)
                print "  "
            end
            puts
        end
        print "\n\n\n"
    end

    def move_piece(start_pos, end_pos)
        start_row, start_col = start_pos
        end_row, end_col = end_pos
        piece = rows[start_row][start_col]

        print "#{rows[start_row][start_col].moves}\n"

        raise "There is no piece at #{start_pos}." if rows[start_row][start_col].is_a?(NullPiece)
        raise "Cannot move pieces off of board." unless valid_pos?(end_pos) && valid_pos?(start_pos)
        raise "Piece cannot move there." unless rows[start_row][start_col].moves.include?(end_pos)

        piece.pos = end_pos
        rows[end_row][end_col], rows[start_row][start_col] = rows[start_row][start_col], NullPiece.instance
        pretty_print_board
    end

    def valid_pos?(pos)
        pos.all? { |n| n.between?(0,7) }
    end
end
x = Board.new
x.move_piece([1,7], [3,7])
x.move_piece([3,7], [4,6])