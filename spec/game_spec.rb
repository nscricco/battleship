require_relative '../game'

describe Game do
  let(:player_name) { 'Nick' }
  let(:ships) { [ Ship.new(name: 'Submarine', size: 2) ] }

  subject do
    described_class.new(player_name: 'Nick', x_len: 2, y_len: 2, ships: ships)
  end

  before { ships[0].place(x: 0, y: 0, direction: 'south') }

  context 'displaying without ships' do
    it 'returns display string with no shots' do
      expect(subject.print(show_ships: false)).to eq(
        "    0   1  \n   --- --- \n0 |   |   |\n   --- --- \n1 |   |   |\n   --- --- \n"
      )
    end

    it 'returns display string with miss' do
      subject.board.send_shot(x: 1, y: 0)
      expect(subject.print(show_ships: false)).to eq(
        "    0   1  \n   --- --- \n0 |   | o |\n   --- --- \n1 |   |   |\n   --- --- \n"
      )
    end

    it 'returns display string with hit' do
      subject.board.send_shot(x: 0, y: 0)
      expect(subject.print(show_ships: false)).to eq(
        "    0   1  \n   --- --- \n0 | x |   |\n   --- --- \n1 |   |   |\n   --- --- \n"
      )
    end
  end

  context 'displaying with ships' do
    it 'returns display string with no shots' do
      expect(subject.print(show_ships: true)).to eq(
        "    0   1  \n   --- --- \n0 | 2 |   |\n   --- --- \n1 | 2 |   |\n   --- --- \n"
      )
    end

    it 'returns display string with miss' do
      subject.board.send_shot(x: 1, y: 0)
      expect(subject.print(show_ships: true)).to eq(
        "    0   1  \n   --- --- \n0 | 2 | o |\n   --- --- \n1 | 2 |   |\n   --- --- \n"
      )
    end

    it 'returns display string with hit' do
      subject.board.send_shot(x: 0, y: 0)
      expect(subject.print(show_ships: true)).to eq(
        "    0   1  \n   --- --- \n0 | x |   |\n   --- --- \n1 | 2 |   |\n   --- --- \n"
      )
    end
  end

  context 'determine if game is complete' do
    it 'returns false when ships remain' do
      expect(subject.complete?).to be_falsey
    end

    it 'returns true when no ships remain' do
      subject.board.send_shot(x: 0, y: 0)
      subject.board.send_shot(x: 0, y: 1)
      expect(subject.complete?).to be_truthy
    end
  end
end
