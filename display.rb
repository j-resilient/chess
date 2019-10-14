require_relative 'board.rb'
require 'colorize'

class Display
    attr_reader :board

    def initialize(board)
        @board = board
    end

    def render
        system("clear")
        print "   "
        (0..7).each { |i| print " #{i} " }
        puts
        board.rows.each_with_index do |row, r_idx| 
            print "#{r_idx}  "
            row.each do |square|
                print square.to_s
            end
            puts
        end
        print "\n\n"
    end
end

board = Board.new
display = Display.new(board)
display.render