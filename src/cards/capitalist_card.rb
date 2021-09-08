require_relative 'card'
class CapitalistCard < Card
  attr_reader :type, :number
  attr_accessor :balance

  def initialize(balance = 100.00)
    super('capitalist', balance)
  end

  def withdraw_tax(amount)
    amount * 0.04
  end

  def put_tax(_amount)
    10
  end

  def send_money(amount)
    amount * 0.1
  end
end
