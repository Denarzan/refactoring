module Input
  def get_input(text = nil)
    puts text if text
    gets.chomp
  end
end
