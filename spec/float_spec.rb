require 'spec_helper'

describe Float do
  describe '#round_down' do
    it 'always round to floor value' do
      expect(1.9.round_down).to eq(1)
      expect(1.725.round_down(2)).to eq(1.72)
      expect(1.71.round_down(1)).to eq(1.7)
    end
  end
end
