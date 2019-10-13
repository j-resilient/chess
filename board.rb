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
            (0..rows.length).each do |col_idx|
                rows[row_idx][col_idx] = Piece.new(:black, self, [row_idx, col_idx])
            end
        end

        (6..7).each do |row_idx|
            (0..rows.length).each do |col_idx|
                rows[row_idx][col_idx] = Piece.new(:white, self, [row_idx, col_idx])
            end
        end

        rows.each do |row| 
            row.each do |square| 
                print square.to_s unless square.nil?
                print square if square.nil?
                print "  "
            end
            puts
        end
    end

    # def move_piece(start_pos, end_pos)
    #     start_row, start_col = start_pos
    #     end_row, end_col = end_pos


    # end
end
x = Board.new