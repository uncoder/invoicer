require 'float'
require 'invoicer/version'
require 'invoicer/rounded_float'
require 'invoicer/calculator'

module Invoicer
  BIG_DECIMAL_PRECISION = 12

  def self.define(&block)
    calculator = Calculator.new
    calculator.instance_eval(&block) if block_given?
    calculator
  end
end
