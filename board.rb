require_relative 'piece'
require_relative 'slideable'
require_relative 'stepable'
require_relative 'nullpiece'
require_relative 'pawn'
require 'byebug'

class Board
    attr_accessor :rows

    def [](pos)
        raise 'Invalid position.' unless valid_pos?(pos)
        row, col = pos
        rows[row][col]
    end

    def []=(pos, val)
        raise 'Invalid position.' unless valid_pos?(pos)
        row, col = pos
        rows[row][col] = val
    end

    def empty?(pos)
        self[pos].empty?
    end

    def initialize(fill = true)
        @rows = Array.new(8) { Array.new(8) }
        fill_board(fill) if fill
    end

    def add_piece(piece, pos)
        row, col = pos
        rows[row][col] = piece
    end

    def move_piece(start_pos, end_pos)
        # so basically all validity checking goes here
        # but the actual moving goes in #move_piece!
        piece = self[start_pos]
        pieces_moves = piece.moves

        raise "There is no piece at #{start_pos}." if self.empty?(start_pos)
        raise "Cannot move pieces off of board." unless valid_pos?(end_pos) && valid_pos?(start_pos)
        raise "Piece cannot move there." unless piece.moves.include?(end_pos)
        raise "Cannot move into check." unless piece.valid_moves.include?(end_pos)

        move_piece!(start_pos, end_pos)
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

    def dup
        # return a deep copy of self
        dup_board = Board.new(false)
        pieces.each do |piece|
            new_piece = piece.class.new(piece.color, dup_board, piece.pos)
            dup_board.add_piece(new_piece, new_piece.pos)
        end
        dup_board.place_null_pieces
        dup_board
    end

    def pieces
        @rows.flatten.reject { |square| square.empty? }
    end

    def place_null_pieces
        rows.each_with_index do |row, row_idx|
            row.each_with_index do |square, col_idx|
                rows[row_idx][col_idx] = NullPiece.instance if square.nil?
            end
        end
    end

    def find_king(color)
        pieces.find { |piece| piece.color == color && piece.is_a?(King) } ||
            (raise "King not found")
    end

    def in_check?(color)
        king_pos = find_king(color).pos
        pieces.any? { |piece| piece.color != color && piece.moves.include?(king_pos) }
    end

    def checkmate?(color)
        return false unless in_check?(color)
        pieces.none? { |piece| piece.color == color && !piece.valid_moves.empty? }
    end

    private
    def fill_board(fill)
        place_pawns(1, :black)
        place_pawns(6, :white)
        place_court(0, :black)
        place_court(7, :white)
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
            Queen.new(color, self, nil),
            King.new(color, self, nil),
            Bishop.new(color, self, nil),
            Knight.new(color, self, nil),
            Rook.new(color, self, nil)
        ]
    end
end
