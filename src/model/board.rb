# frozen_string_literal: true

require_relative './cell'
require_relative '../observer/observable'
require_relative '../utils/board_creators'

# models a Minesweeper Board
class Board < Observable
  attr_accessor :matrix_board, :dimensions, :completed

  def initialize(dimensions, bombs, game = nil)
    super()
    @matrix_board = Array.new(dimensions) { Array.new(dimensions, nil) }
    @dimensions = dimensions
    @bombs = bombs
    @completed = false
    @cells_revealed = 0
    if game.nil?
      create_board
    else
      @matrix_board = game.map { |line| line.map { |value| Cell.new(value) } }
    end
  end

  def return_value(y_dim, x_dim)
    @matrix_board[y_dim][x_dim]
  end

  def create_board
    generate_permutations(@dimensions, @bombs).each do |x, y|
      @matrix_board[x][y] = Cell.new('B')
    end
    @matrix_board.each_with_index do |cell_list, x|
      cell_list.each_with_index do |cell_value, y|
        next unless cell_value.nil?

        count = count_surrounding(self, x, y)
        @matrix_board[x][y] = Cell.new(count)
      end
    end
  end

  def reveal_cell(cord_x, cord_y)
    value = @matrix_board[cord_x][cord_y].reveal
    @cells_revealed += 1
    @completed = true if @cells_revealed == @dimensions**2 - @bombs
    value
  end
end
