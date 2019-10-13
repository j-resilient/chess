require_relative 'piece'
require_relative 'slideable'
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
        
        (6..7).each do |row_idx|
            (0...rows.length).each do |col_idx|
                new_piece = Piece.new(:White, self, [row_idx, col_idx])
                add_piece(new_piece, [row_idx, col_idx])
            end
        end
        rook = Rook.new(:Black, self, [3,4])
        add_piece(rook, [3,4])

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
                print square.to_s unless square.nil?
                print "_____" if square.nil?
                print "  "
            end
            puts
        end
        print "\n\n\n"
    end

    def move_piece(start_pos, end_pos)
        start_row, start_col = start_pos
        end_row, end_col = end_pos

        raise "There is no piece at #{start_pos}." if rows[start_row][start_col].nil?
        raise "Cannot move pieces off of board." unless valid_pos?(end_pos) && valid_pos?(start_pos)
        raise "Piece cannot move there." unless rows[start_row][start_col].moves.include?(end_pos)

        rows[end_row][end_col], rows[start_row][start_col] = rows[start_row][start_col], nil
        pretty_print_board
    end

    def valid_pos?(pos)
        pos.all? { |n| n.between?(0,7) }
    end
end
x = Board.new
x.move_piece([3,4], [6,4])