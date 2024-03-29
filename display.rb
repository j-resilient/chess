require_relative 'board.rb'
require_relative 'cursor.rb'
require 'colorize'

class Display
    attr_reader :board, :cursor

    def initialize(board)
        @board = board
        @cursor = Cursor.new([0,0],board)
        @check = false
    end

    def check
        @check = true
    end

    def uncheck
        @check = false
    end

    def render
        system("clear")
        puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
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
        puts "Check!" if @check
        print "\n"
    end
end
