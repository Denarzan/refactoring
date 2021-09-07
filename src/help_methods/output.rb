module Output
  def multiline_output(key)
    I18n.t(key).split("\n").each { |line| puts line }
  end
end
