WINS = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]



class Game
  def initialize(player1_sentience)
    @board = Array.new(10)
    player1_sentience == "human" ? @player1 = HumanPlayer.new(1, "X", "Human Player", self) : @player1 = ComputerPlayer.new(1, "X", "Computer X", self)
    @player2 = ComputerPlayer.new(2, "O", "Computer O", self)
    @markers = ["X", "O"]
    @current_player = @player1
    @other_player = @player2
  end
  attr_reader :board, :current_player, :print_board

  def play
    loop do
      print_board
      place_marker(@current_player)

      if player_has_won?(@current_player)
        puts "#{@current_player.name} wins! Congrats!\n"
        print_board
        return
      elsif board_full?
        puts "It's a tie!!"
        print_board
        return
      end
      switch_player!
    end
  end


  def player_has_won?(player)
    WINS.any? do |line|
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
    if @markers.include?(@board[position])
      puts "That square has already been taken please select another"
    else
      return @board[position] = @current_player.marker
      
      
    end
  end
  end
end




class Player < Game
  def initialize(turn, marker, name, game)
    @turn = turn
    @marker = marker
    @name = name
    @game = game
  end
  attr_reader :marker, :name 
end


class HumanPlayer < Player
  def make_move
      print "Please select a square!"
      selection = gets.chomp.to_i
      selection
  
  end
end


class ComputerPlayer < Player
  @@prior_selectionsX = []
  @@prior_selectionsO = []
  def make_move
    
    corners = [1,3,7,9]
      if @turn == 1
        @turn += 2
        selection = corners.sample
        @@prior_selectionsX << selection
        selection 
      elsif @turn == 2
        @turn += 2
        @@prior_selectionsO << 5
        selection = 5
      elsif @turn == 3
        @turn += 2
        last_move = @@prior_selectionsX[0].to_i
        best_moves = {1=>[2,4], 3=>[2,6], 7=>[4,8], 9=>[6,8]}
        selection = best_moves[last_move].sample
        @@prior_selectionsX << selection
        selection
      elsif WINS.any? {|line| (line - @@prior_selectionsX).length == 1}
        near_wins = WINS.map {|line| (line - @@prior_selectionsX)}
        move = near_wins.select {|n| n.length == 1}
        selection = move[0].sample
          if (@game.free_positions).include?(selection)
            @game.current_player.marker == "X" ? @@prior_selectionsX << selection : @@prior_selectionsO << selection
          selection = move[0].sample
          else
            selection = @game.free_positions[rand(@game.free_positions.length)]
          
          end
       
      elsif WINS.any? {|line| (line - @@prior_selectionsO).length == 1}
        near_wins = WINS.map {|line| line - @@prior_selectionsO}
        move = near_wins.select {|n| n.length == 1}
        selection = move[0].sample
          if (@game.free_positions).include?(selection)
            @game.current_player.marker == "X" ? @@prior_selectionsX << selection : @@prior_selectionsO << selection
            selection = move[0].sample
          else
            selection = @game.free_positions[rand(@game.free_positions.length)]
            
          end
      
      else
        selection = @game.free_positions[rand(@game.free_positions.length)]
    
    end
      
    puts "\n#{@name} selects #{selection}"
    selection.to_i
  end
end




Game.new("computer").play
