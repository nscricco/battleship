require_relative 'ship'
require_relative 'board'

class Game
  HIT_CHAR = "x"
  MISS_CHAR = "o"

  attr_reader :player_name, :board, :ships
  attr_accessor :opponent_name

  def initialize(player_name:, x_len: 10, y_len: 10, ships: nil)
    @player_name = player_name
    @board = Board.new(x_len: x_len, y_len: y_len)
    @ships = ships || [
      Ship.new(name: 'Aircraft Carrier', size: 5),
      Ship.new(name: 'Battleship', size: 4),
      Ship.new(name: 'Submarine', size: 3),
      Ship.new(name: 'Destroyer', size: 3),
      Ship.new(name: 'Patrol Boat', size: 2)
    ]
  end

  def print(show_ships:)
    b = "  "

    board.x_len.times { |x| b << "  #{x} " }
    b << " \n  " + " ---" * board.y_len + " \n"

    board.y_len.times do |y|
      b << "#{y} "
      board.x_len.times do |x|
        b << "| #{ board_char_at(x: x, y: y, show_ships: show_ships) } "
      end
      b << "|\n  " + " ---" * board.y_len + " \n"
    end

    return b
  end

  def ship_at(x:, y:)
    ships_and_positions.find { |s| s[:x] == x && s[:y] == y }
  end

  def complete?
    ships.
      reduce([]) { |d, s| d += s.occupied_cells }.
      reject { |p| board.shot_at?(x: p[:x], y: p[:y]) }.
      length == 0
  end

  private

  def ships_and_positions
    ships.reduce([]) do |d, s|
      d += s.occupied_cells.map { |p| p.merge(c: s.size.to_s) }
    end
  end

  def board_char_at(x:, y:, show_ships:)
    ship = ship_at(x: x, y: y)
    shot = board.shot_at?(x: x, y: y)

    if !shot
      show_ships && !!ship ? ship[:c] : " "
    else
      !!ship ? HIT_CHAR : MISS_CHAR
    end
  end
end

if __FILE__ == $0
  puts "\e[H\e[2J"
  puts "Welcome to Battleship..."

  games = []
  puts "enter player 1 name"
  games << Game.new(player_name: gets.chomp)

  puts "enter player 2 name"
  games << Game.new(player_name: gets.chomp)

  games[0].opponent_name = games[1].player_name
  games[1].opponent_name = games[0].player_name

  games.reverse.each do |game|
    while ship = game.ships.find { |s| !s.placed? }
      puts "\e[H\e[2J"
      puts "#{game.opponent_name} place your ships"
      puts "directions: you will enter an x position, a y position and a direction (north, east, south, west)"
      puts game.print(show_ships: true)

      puts "placing #{ship.name}: #{ship.size}"
      puts "x ="
      x = gets.chomp.to_i
      puts "y ="
      y = gets.chomp.to_i
      puts "direction ="
      direction = gets.chomp.downcase
      begin
        ship.place(x: x, y: y, direction: direction)
      rescue Ship::InvalidDirection
        puts "please use a valid direction (north, east, south, west)"
        sleep(2)
      rescue Ship::InvalidPosition
        puts "please use a position on the board x (0 to #{board.x_len - 1}) and y (0 to #{board.y_len - 1})"
        sleep(2)
      rescue Ship::PlacementOutOfBounds
        puts "looks like your ship went off the board, please place again"
        sleep(2)
      end
    end

    puts "\e[H\e[2J"
    puts "#{ game.opponent_name }'s final board:"
    puts game.print(show_ships: true)
    puts "press any key to continue"
    gets
  end

  i = 0
  while !games.any? { |g| g.complete? }
    my_game = games[i % 2]
    opponent_game = games[(i + 1) % 2]

    puts "\e[H\e[2J"
    puts "#{my_game.player_name}'s turn, press any key to continue..."
    gets

    puts "\e[H\e[2J"
    puts "defense:"
    puts opponent_game.print(show_ships: true)
    puts "offense:"
    puts my_game.print(show_ships: false)

    puts "x ="
    x = gets.chomp.to_i
    puts "y ="
    y = gets.chomp.to_i
    my_game.board.send_shot(x: x, y: y)

    if my_game.ship_at(x: x, y: y)
      puts "HIT!"
    else
      puts "miss"
    end

    sleep(1)
    i += 1
  end

  winner = games.find { |g| g.complete? }
  puts "\e[H\e[2J"
  puts "#{winner.player_name} wins!"

  games.each do |game|
    puts "\n"
    puts game.player_name
    puts game.print(show_ships: true)
  end
end
