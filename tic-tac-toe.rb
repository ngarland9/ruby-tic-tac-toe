LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

class Game
  def initialize()
    @board = Array.new(10)
  
    @player1 = HumanPlayer.new(1, "X")
    @player2 = ComputerPlayer.new(2, "O")

    @current_player = @player1
    @other_player = @player2
  end
  attr_reader :board, :current_player, :print_board

  def play()
    loop do
      print_board
      place_marker(@current_player)

      if player_has_won?(@current_player)
        puts "#{@current_player} wins!"
        print_board
        return
      elsif board_full?
        puts "It's a draw."
        print_board
        return
      end
      switch_player!
    end
  end


  def player_has_won?(player)
    LINES.any? do |line|
      line.all? {|position| @board[position] == player.marker}
    end
  end
  
  def board_full?
    free_positions.empty?
  end

  def switch_player!
    @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
  end

  def free_positions
    (1..9).select {|position| @board[position].nil?}
  end

  def print_board
    col_separator, row_separator = " | ", "--+---+--"
    label_for_position = lambda{|position| @board[position] ? @board[position] : position}
     
     row_for_display = lambda{|row| row.map(&label_for_position).join(col_separator)}
     row_positions = [[1,2,3], [4,5,6], [7,8,9]]
     rows_for_display = row_positions.map(&row_for_display)
     puts rows_for_display.join("\n" + row_separator + "\n")
  end


  def place_marker(player)
    loop do 
      position = player.make_move
    if (1..9).include?(position)
      return @board[position] = @current_player.marker
    else
      puts "That square has already been taken please select another"
      
    end
  end
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
      print "Please select a square!"
      selection = gets.chomp.to_i
      selection
  
  end
end


class ComputerPlayer < Player
  def make_move
      selection = rand(1..9)
      puts "Computer selects #{selection}"
      selection.to_i
    
  end
end




Game.new.play