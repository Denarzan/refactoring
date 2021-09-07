require 'yaml'
require 'pry'
require_relative '../console'

class Account
  attr_accessor :login, :name, :cards, :password

  def initialize(name, login, password, age)
    @name = name
    @login = login
    @cards = []
    @password = password
    @age = age
  end

  def add_card(card)
    @cards << card
  end

  def find_card(index)
    @cards[index - 1] if index.to_i != 0 && index.between?(1, @cards.length)
  end

  def remove_card(index)
    @cards.delete_at(index - 1)
  end

end
