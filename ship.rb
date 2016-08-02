class Ship
  class InvalidDirection < StandardError; end
  class InvalidPosition < StandardError; end
  class PlacementOutOfBounds < StandardError; end
  class AlreadyPlacedOnBoard < StandardError; end

  attr_reader :name, :size, :occupied_cells

  def initialize(name:, size:)
    @name = name
    @size = size
    @occupied_cells = []
  end

  def place(x:, y:, direction:, x_len: 10, y_len: 10)
    raise AlreadyPlacedOnBoard if placed?
    raise InvalidPosition if x < 0 || x >= x_len || y < 0 || y >= y_len

    case direction.to_sym
    when :north
      raise PlacementOutOfBounds if y - size + 1 < 0
      size.times { |i| occupied_cells << { x: x, y: y - i } }
    when :south
      raise PlacementOutOfBounds if y + size > y_len
      size.times { |i| occupied_cells << { x: x, y: y + i } }
    when :east
      raise PlacementOutOfBounds if x + size > x_len
      size.times { |i| occupied_cells << { x: x + i, y: y } }
    when :west
      raise PlacementOutOfBounds if x - size + 1 < 0
      size.times { |i| occupied_cells << { x: x - i, y: y } }
    else
      raise InvalidDirection
    end
  end

  def placed?
    !occupied_cells.empty?
  end
end
