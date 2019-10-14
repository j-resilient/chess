require_relative 'board.rb'
require_relative 'cursor.rb'
require 'colorize'

class Display
    attr_reader :board, :cursor

    def initialize(board)
        @board = board
        @cursor = Cursor.new([0,0],board)
    end

    def render
        system("clear")
        print "   "
        (0..7).each { |i| print " #{i} " }
        puts
        board.rows.each_with_index do |row, r_idx| 
            print "#{r_idx}  "
            row.each_with_index do |square, c_idx|
                background = cursor.cursor_pos == [r_idx, c_idx] ? :light_green : :default
                background = :magenta if background == :light_green && cursor.selected

                print square.to_s.colorize(:background => background)
            end
            puts
        end
        print "\n\n"
    end

    def run
        x = 0
        until x == 5
            render
            cursor.get_input
            x += 1
        end
    end
end

board = Board.new
display = Display.new(board)
display.render

board.move_piece([6,5],[5,5])
display.render
sleep(1)
board.move_piece([1,4],[3,4])
display.render
sleep(1)
board.move_piece([6,6],[4,6])
display.render
# sleep(1)
# board.move_piece([0,3],[4,7])
# display.render

puts board.in_check?(:white)