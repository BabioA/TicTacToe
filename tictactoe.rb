class Game
  attr_reader :player1, :player2, :grid

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @grid = Grid.new
  end

  def play
    i = 0
    until finished? do
      current_player, character = switching_players(i)
      grid.print
      many_tries = false 
      begin 
        puts 'invalid move' if many_tries
        move = current_player.move 
        many_tries = true
      end until grid.valid?(move)
      grid.update(move, character)
      i += 1
    end
    grid.print
    result = grid.result 
    puts result
  end

  def finished?
    grid.finished?
  end

  def switching_players(i)
    if i.even? 
      switching_players = player1
      character = 'X'
    else
      switching_players = player2
      character = 'O'
    end
    [switching_players, character]
  end
end

class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def move 
    puts "Put your next move: (in 'row, column' format)"
    answer = gets.chomp.split(",")
    answer.map do |value|
      value.to_i - 1
    end
  end
end

class Grid 
  def initialize()
    @grid = [
      ['.', '.', '.'],
      ['.', '.', '.'],
      ['.', '.', '.']
    ]
  end

  def print
    puts [" ",1, 2, 3].join("   ") 
    puts "  " + "+---"*3 + "+"
    $stdout.print "1 | "
    puts @grid[0].join(" | ") + ' |'
    puts "  " + "+---"*3 + "+"
    $stdout.print "2 | "
    puts @grid[1].join(" | ") + ' |'
    puts "  " + "+---"*3 + "+"
    $stdout.print "3 | "
    puts @grid[2].join(" | ") + ' |'
    puts "  " + "+---"*3 + "+"
  end

  def update(move, character)
    @grid[move[0]][move[1]] = character
  end

  def finished?
    winner?('X') || winner?('O') || tie 
  end

  def winner?(character)
    by_columns = @grid.transpose
    @grid[0].all?(character) || @grid[1].all?(character) || @grid[2].all?(character) ||
    by_columns[0].all?(character) || by_columns[1].all?(character) || by_columns[2].all?(character) ||
    (@grid[0][0] == character && @grid[1][1] == character && @grid[2][2] == character) ||
    (@grid[0][2] == character && @grid[1][1] == character && @grid[2][0] == character) 
  end 

  def tie 
    (!@grid.flatten.any?('.') && !@grid.flatten.all?('.'))
  end 

  def result
    return 'X' if winner?('X') 
    return 'O' if winner?('O')
    'tie'
  end

  def valid?(move)
    @grid[move[0]][move[1]] == '.'
  end 
end

puts "Ingrese nombre del jugador 1"
player1 = Player.new(gets.chomp)
puts "Enter the name of player 2"
player2 = Player.new(gets.chomp)

match = Game.new(player1, player2)
match.play
