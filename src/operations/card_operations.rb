module Banking
  class CardOperations
    include HelpOperations

    CARD_TYPES = %w[usual capitalist virtual].freeze

    def initialize(storage, account)
      @storage = storage
      @account = account
    end

    def create_card_operation?(card_type)
      if CARD_TYPES.include?(card_type)
        chose_type(card_type)
        @storage.save_accounts
        true
      else
        false
      end
    end

    def destroy_card_operation(index)
      @account.remove_card(index)
      @storage.save_accounts
    end

    def show_cards_operation
      return unless card_exist?(@account)

      @account.cards.each
    end

    private

    def chose_type(card_type)
      case card_type
      when 'usual' then @account.add_card(Card::UsualCard.new)
      when 'capitalist' then @account.add_card(Card::CapitalistCard.new)
      when 'virtual' then @account.add_card(Card::VirtualCard.new)
      else
        false
      end
    end
  end
end
