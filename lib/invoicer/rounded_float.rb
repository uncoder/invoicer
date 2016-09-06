require 'bigdecimal'

module Invoicer
  class RoundedFloat
    attr_reader :float, :rounded, :remain

    # round down float and store rounded and remain value
    def initialize(float, exp = 0)
      @float = float
      @rounded = BigDecimal.new(float.round_down(exp), BIG_DECIMAL_PRECISION)
      @remain = (float - @rounded).to_f
    end

    def round_values
      {
        rounded: @rounded,
        remain: @remain
      }
    end
  end
end
