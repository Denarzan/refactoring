require_relative 'card'
class UsualCard < Card
  attr_reader :type, :number
  attr_accessor :balance

  def initialize(balance: 50.00)
    super('usual', balance)
  end

  def withdraw_tax(amount)
    amount * 0.05
  end

  def put_tax(amount)
    amount * 0.02
  end

  def send_money(_amount)
    20
  end
end
