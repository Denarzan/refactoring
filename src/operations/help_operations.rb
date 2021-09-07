module HelpOperations
  include Input
  include Output

  def take_card_number(account)
    card_input = chose_card(account)
    nil if card_input == 'exit'
  end

  def chose_card(account)
    card = account.find_card(get_input)
    if card.nil?
      puts I18n.t('card.wrong')
      return
    end
    card
  end

  def show_cards(account, first_message, second_message, exit_message)
    puts I18n.t(first_message)

    account.cards.each_with_index do |card, index|
      puts I18n.t(second_message, card_number: card.number, card_type: card.type, index: index + 1)
    end
    puts I18n.t(exit_message)
  end

  def card_exist?(account)
    return true if account.cards.any?

    puts I18n.t('card.no_cards')
    false
  end
end
