require 'spec_helper'

describe Invoicer::Calculator do
  let :calculator do
    Invoicer::Calculator.new
  end

  let :items do
    [
      { price: 1.50, qty: 2, vat: 16 },
      { price: 0.73, qty: 1, vat: 16 },
      { price: 1.2345, qty: 1, vat: 18 },
    ]
  end

  describe '#add_items' do
    it 'add items to instance variable' do
      calculator.add_items items, unit_amount: :price, qty: :qty, vat: :vat
      expect(calculator.instance_variable_get(:@items)).to include(
        { unit_amount: 1.50, qty: 2, vat: 16 },
        { unit_amount: 0.73, qty: 1, vat: 16 },
        { unit_amount: 1.2345, qty: 1, vat: 18 }
      )
    end
  end

  describe '#calculate' do
    before :each do
      @calculator = Invoicer::Calculator.new
      @calculator.add_items items, unit_amount: :price, qty: :qty, vat: :vat
    end

    it 'calls private methods' do
      expect_any_instance_of(Invoicer::Calculator).to receive(:reset_totals)
      expect_any_instance_of(Invoicer::Calculator).to receive(:round_totals)
      expect_any_instance_of(Invoicer::Calculator).to receive(:check_and_correct_amounts)
      @calculator.calculate
    end

    it 'store group totals' do
      @calculator.calculate
      group_totals = @calculator.instance_variable_get(:@group_totals)
      expect(group_totals[16][:amount][:rounded]).to eq(3.73)
      expect(group_totals[16][:amount][:remain]).to eq(0)
      expect(group_totals[16][:vat_amount][:rounded]).to eq(0.6)
      expect(group_totals[16][:vat_amount][:remain]).to eq(0.0068)
    end

    it 'store invoice totals' do
      @calculator.calculate
      invoice_totals = @calculator.instance_variable_get(:@invoice_totals)
      expect(invoice_totals[:amount]).to eq(4.9645)
      expect(invoice_totals[:vat_amount]).to eq(0.81901)
      expect(invoice_totals[:total_amount]).to eq(4.9645 + 0.81901)
    end
  end

  describe '#invoice_totals' do
    it 'makes hash from rounded totals' do
      @calculator = Invoicer::Calculator.new
      @calculator.instance_variable_set(:@invoice_totals, {
        'rounded_amount' => 1.1211, 'rounded_vat_amount' => BigDecimal.new(2.34, 10), 'rounded_total_amount' => 3.45
      })
      expect(@calculator.invoice_totals).to include({ amount: "#{1.12}", vat_amount: "#{2.34}", total_amount: "#{3.45}" })
    end
  end

  describe '#group_totals' do
    it 'makes hash from rounded totals' do
      @calculator = Invoicer::Calculator.new
      @calculator.instance_variable_set(:@group_totals, {
        16 => { amount: { rounded: 1.1211 }, vat_amount: { rounded: BigDecimal.new(2.34, 10) }, total_amount: { rounded: 3.45 } }
      })
      expect(@calculator.group_totals[16]).to include({ amount: "#{1.12}", vat_amount: "#{2.34}", total_amount: "#{3.45}" })
    end
  end

  describe 'Private methods' do
    describe '#reset_totals' do
      before :each do
        calculator.send(:reset_totals)
      end

      it 'resets invoice totals' do
        [:amount, :vat_amount, :total_amount].each do |key|
          expect(calculator.instance_variable_get(:@invoice_totals)[key]).to eq(0)
        end
      end

      it 'resets group totals' do
        expect(calculator.instance_variable_get(:@group_totals)).to be_empty
      end
    end

    describe '#check_and_correct_amounts' do
      it 'corrects ammounts for group' do
        items = [
          { price: 1.2359, qty: 1, vat: 10 },
          { price: 0.0976, qty: 1, vat: 11 }
        ]
        calculator = Invoicer::Calculator.new
        calculator.add_items items, unit_amount: :price, qty: :qty, vat: :vat
        calculator.calculate
        expect(calculator.group_totals[10]).not_to eq(1.2359.round(2))
        expect(calculator.group_totals[11]).not_to eq(0.0976.round(2))
      end
    end
  end
end
