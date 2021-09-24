module Banking
  module Account
    class Account
      attr_accessor :login, :name, :cards, :password, :age

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
        @cards[index.to_i - 1] if index.to_i != 0 && index.to_i.between?(1, @cards.length)
      end

      def remove_card(card)
        @cards.delete(card)
      end
    end
  end
end
