require 'spec_helper'

describe Invoicer::RoundedFloat do
  it "sets all values on initialize" do
    rounded_float = Invoicer::RoundedFloat.new(1.7598, 2)
    expect(rounded_float.float).to eq(1.7598)
    expect(rounded_float.rounded).to eq(1.75)
    expect(rounded_float.remain).to eq(0.0098)
  end

  describe "#round_values" do
    it "returns rounded value and remain" do
      rounded_float = Invoicer::RoundedFloat.new(1.2345, 2)
      expect(rounded_float.round_values).to eq({ rounded: 1.23, remain: 0.0045})
    end
  end
end
