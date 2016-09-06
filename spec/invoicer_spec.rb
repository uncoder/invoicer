require 'spec_helper'

describe Invoicer do
  it 'has a version number' do
    expect(Invoicer::VERSION).not_to be nil
  end

  describe '.define' do
    it 'returns calculator instance' do
      expect(Invoicer.define).to be_kind_of(Invoicer::Calculator)
    end

    it 'calls calculator add_items method' do
      expect_any_instance_of(Invoicer::Calculator).to receive(:add_items)
      Invoicer.define do
        add_items [{ unit_amount: 1.50, qty: 2, vat: 16 }], unit_amount: :price, qty: :qty, vat: :vat
      end
    end
  end
end
