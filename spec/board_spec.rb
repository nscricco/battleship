require_relative '../board'

describe Board do
  let(:width) { 10 }
  let(:height) { 10 }

  subject { described_class.new(x_len: width, y_len: height) }

  it 'has a width' do
    expect(subject.x_len).to eq(width)
  end

  it 'has a height' do
    expect(subject.y_len).to eq(height)
  end

  context 'making moves' do
    it 'does not allow moves outside of the board' do
      expect { subject.send_shot(x: width + 1, y: height + 1) }.to(
        raise_exception(Board::InvalidPosition)
      )
    end

    it 'does not allow the same move twice' do
      args = { x: 0, y: 0 }
      subject.send_shot(**args)
      expect { subject.send_shot(**args) }.to(
        raise_exception(Board::AlreadyAttemptedPosition)
      )
    end

    it 'stores the moves' do
      subject.send_shot(x: 0, y: 0)
      subject.send_shot(x: 1, y: 1)
      expect(subject.instance_variable_get('@moves')).to(
        eq([{ x: 0, y: 0 }, { x: 1, y: 1 }])
      )
    end
  end

  context 'finding moves' do
    it 'returns false if a move has not been made' do
      expect(subject.shot_at?(x: 0, y: 0)).to be_falsey
    end

    it 'returns true if move has been made at that spot' do
      subject.send_shot(x: 0, y: 0)
      expect(subject.shot_at?(x: 0, y: 0)).to be_truthy
    end
  end
end
