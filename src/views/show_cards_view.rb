class ShowCardsView < BaseView

  def show_cards_module(account_operations)
    cards = account_operations.card_operations.show_cards_operation
    return Output.no_cards if cards.nil?

    cards.each do |card|
      Output.show_card(card.number, card.type)
    end
  end
end
