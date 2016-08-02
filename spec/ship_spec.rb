require_relative '../ship'

describe Ship do
  let(:name) { 'name' }
  let(:size) { 2 }

  subject { described_class.new(name: name, size: size) }

  it 'has a name' do
    expect(subject.name).to eq(name)
  end

  it 'has a size' do
    expect(subject.size).to eq(size)
  end

  context 'placing on board' do
    it 'raises for invalid compass direction' do
      args = { x: 0, y: 0, direction: 'left' }

      expect { subject.place(**args) }.to(
        raise_exception(Ship::InvalidDirection)
      )
    end

    it 'raises for invalid position' do
      args = { x: 100, y: 0, direction: 'south' }

      expect { subject.place(**args) }.to(
        raise_exception(Ship::InvalidPosition)
      )
    end

    it 'raises when ship leaves board' do
      cases = [
        { x: 0, y: 0, direction: 'north' },
        { x: 9, y: 9, direction: 'south' },
        { x: 9, y: 9, direction: 'east' },
        { x: 0, y: 0, direction: 'west' }
      ]

      cases.each do |args|
        expect { subject.place(**args) }.to(
          raise_exception(Ship::PlacementOutOfBounds)
        )
      end
    end

    it 'raises when a ship is placed twice' do
      args = { x: 0, y: 0, direction: 'south' }

      subject.place(**args)
      expect { subject.place(**args) }.to(
        raise_exception(Ship::AlreadyPlacedOnBoard)
      )
    end

    it 'properly assigns occupied cells' do
      cases = [
        [{ x: 0, y: 1, direction: 'north' }, [{ x: 0, y: 0 }, { x: 0, y: 1 }]],
        [{ x: 0, y: 0, direction: 'south' }, [{ x: 0, y: 0 }, { x: 0, y: 1 }]],
        [{ x: 0, y: 0, direction: 'east' }, [{ x: 0, y: 0 }, { x: 1, y: 0 }]],
        [{ x: 1, y: 0, direction: 'west' }, [{ x: 0, y: 0 }, { x: 1, y: 0 }]]
      ]

      cases.each do |args, result|
        subject.place(**args)
        expect(subject.instance_variable_get('@occupied_cells')).to(
          match_array(result)
        )
        subject.instance_variable_set('@occupied_cells', [])
      end
    end
  end

  describe '.placed?' do
    it 'returns false when not placed' do
      expect(subject.placed?).to be_falsey
    end

    it 'returns true when placed' do
      subject.place(x: 0, y: 0, direction: 'south')
      expect(subject.placed?).to be_truthy
    end
  end
end
