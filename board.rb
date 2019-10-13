require_relative 'piece'
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
                add_piece(:black, [row_idx, col_idx])
                # rows[row_idx][col_idx] = Piece.new(:black, self, [row_idx, col_idx])
            end
        end
        
        (6..7).each do |row_idx|
            (0...rows.length).each do |col_idx|
                add_piece(:white, [row_idx, col_idx])
                # rows[row_idx][col_idx] = Piece.new(:white, self, [row_idx, col_idx])
            end
        end

        pretty_print_board
    end

    def add_piece(color, pos)
        row, col = pos
        rows[row][col] = Piece.new(color, self, pos)
    end

    def pretty_print_board
        rows.each do |row| 
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

        rows[end_row][end_col], rows[start_row][start_col] = rows[start_row][start_col], rows[end_row][end_col]
        pretty_print_board
    end

    def valid_pos?(pos)
        pos.all? { |n| n.between?(0,7)}
    end
end
x = Board.new
x.move_piece([1,7], [2,7])