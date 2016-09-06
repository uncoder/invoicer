class Float
  # round to floor value
  def round_down(exp = 0)
    multiplier = 10 ** exp
    ((self * multiplier).floor).to_f / multiplier.to_f
  end
end
