class Card
  def initialize(type, balance: 0)
    @type = type
    @number = 16.times.map { rand(10) }.join
    @balance = balance
  end

  def withdraw_money(amount)
    @balance -= amount - withdraw_tax(amount)
  end

  def put_money(amount)
    @balance += amount - put_tax(amount)
  end

  def send_money(amount)
    @balance -= amount - sender_tax(amount)
  end

  def withdraw_tax(_amount)
    0
  end

  def put_tax(_amount)
    0
  end

  def sender_tax(_amount)
    0
  end

  def withdraw_money?(amount)
    (@balance - amount - withdraw_tax(amount)).positive?
  end

  def put_money?(amount)
    put_tax(amount) < amount
  end

  def send_money?(amount)
    (@balance - amount - sender_tax(amount)).positive?
  end
end
