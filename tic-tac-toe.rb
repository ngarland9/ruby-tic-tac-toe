LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

class Game
  def initialize()
    @board = Array.new(10)
    @current_player = 0
    @other_player = 0
    @player1 = Player.new(1, "X")
    @player2 = Player.new(2, "O")
  end
  attr_reader :board, :current_player

  def play()
    loop do
      place_marker(@current_player)


  end
  def switch_player()
    @current_player = @other_player
  end
  def PrintBoard
    col_separator, row_separator = " | ", "--+---+--"
    label_for_position = lambda{|position| @board[position] ? @board[position] : position}
     
     row_for_display = lambda{|row| row.map(&label_for_position).join(col_separator)}
     row_positions = [[1,2,3], [4,5,6], [7,8,9]]
     rows_for_display = row_positions.map(&row_for_display)
     puts rows_for_display.join("\n" + row_separator + "\n")
  end
  def place_marker(player)
    position = player.make_move
    @board[position] = @current_player.marker
  end
end

class Player < Game
  def initialize(turn, marker)
    @turn = turn
    @marker = marker
  end
  attr_reader :marker
end


class HumanPlayer < Player
  def make_move
    Game.PrintBoard
      print "Please select a square!"
      selection = gets.chomp.to_i
      selection
  
  end
end
