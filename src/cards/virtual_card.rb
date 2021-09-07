require_relative 'card'
class VirtualCard < Card
  attr_reader :type, :number
  attr_accessor :balance

  def initialize(balance: 150.00)
    super('virtual', balance)
  end

  def withdraw_tax(amount)
    amount * 0.88
  end

  def put_tax(_amount)
    1
  end

  def send_money(_amount)
    1
  end
end
