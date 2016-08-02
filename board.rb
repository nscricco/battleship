class Board
  class InvalidPosition < StandardError; end
  class AlreadyAttemptedPosition < StandardError; end

  attr_reader :x_len, :y_len

  def initialize(x_len: 10, y_len: 10)
    @x_len = x_len
    @y_len = y_len
    @moves = []
  end

  def send_shot(x:, y:)
    raise InvalidPosition if x < 0 || x >= x_len || y < 0 || y >= y_len
    raise AlreadyAttemptedPosition if shot_at?(x: x, y: y)

    @moves << { x: x, y: y }
  end

  def shot_at?(x:, y:)
    @moves.any? { |m| m[:x] == x && m[:y] == y }
  end
end
