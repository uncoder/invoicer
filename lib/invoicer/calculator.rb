module Invoicer
  class Calculator

    def initialize
      @amount_fields = [:amount, :vat_amount, :total_amount]
      @items = []
      reset_totals
    end

    def add_items(items, fields = {})
      # append and map items
      items_list = items.map do |item|
        formatted_item = {}
        [:unit_amount, :qty, :vat].each { |key| formatted_item[key] = item[fields[key]] }
        formatted_item
      end
      @items = @items.concat items_list
    end

    def calculate
      reset_totals

      # group items and iterate
      grouped_items.each do |vat, items|
        # round down amounts
        amount = RoundedFloat.new(items.map { |i| i[:unit_amount] * i[:qty] }.inject(:+), 2)
        vat_amount = RoundedFloat.new(amount.float / 100 * vat, 2)
        total_amount = RoundedFloat.new(amount.float + vat_amount.float, 2)

        # store round values to group totals for mapping
        @group_totals[vat] = {
          amount: amount.round_values,
          vat_amount: vat_amount.round_values,
          total_amount: total_amount.round_values,
        }

        # store accurate values for total amounts
        @invoice_totals[:amount] += amount.float
        @invoice_totals[:vat_amount] += vat_amount.float
        @invoice_totals[:total_amount] += total_amount.float
      end

      round_totals
      check_and_correct_amounts
    end

    def invoice_totals
      Hash[
        *@amount_fields.collect { |k| [ k, sprintf('%.2f', @invoice_totals["rounded_#{k}"]) ] }.flatten
      ]
    end

    def group_totals
      readable_group_totals = {}
      @group_totals.keys.each do |vat|
        readable_group_totals[vat] = Hash[
          *@amount_fields.collect { |k| [ k, sprintf('%.2f', @group_totals[vat][k][:rounded]) ] }.flatten
        ]
      end
      readable_group_totals
    end

    private

    def check_and_correct_amounts
      # correct all amounts
      @amount_fields.each do |key|
        # check if need correction (total - aggregated)
        aggregated_amount = @group_totals.map { |g| g[1][key][:rounded] }.inject(:+)
        total_amount = @invoice_totals["rounded_#{key}"]
        diff = ((total_amount - aggregated_amount) * 100).to_i
        # correct amount
        if diff > 0
          # make list of remains
          list = @group_totals.map { |g| { vat: g[0], remain: g[1][key][:remain] } }
          # sort list by remains DESC
          list = list.sort_by {|g| g[:remain] }.reverse
          # add by 1 cent from diff to elements with bigest remain
          list.take(diff).each do |list_item|
            @group_totals[list_item[:vat]][key][:rounded] += 0.01
          end
        end
      end
    end

    def grouped_items
      @items.group_by { |item| item[:vat] }
    end

    def reset_totals
      @invoice_totals = Hash.new(BigDecimal.new(0, BIG_DECIMAL_PRECISION))
      @group_totals = {}
    end

    def round_totals
      # use normal rounding for invoice totals
      @invoice_totals.keys.each do |key|
        @invoice_totals["rounded_#{key}"] = BigDecimal.new(
          @invoice_totals[key].round(2), BIG_DECIMAL_PRECISION
        )
      end
    end
  end
end
