module HelpOperations
  include Input
  include Output

  private

  def take_card_number(account)
    input = get_input
    return if input == 'exit'

    card = account.find_card(input)
    if card.nil?
      puts I18n.t('card.wrong')
      take_card_number(account)
    end
    card
  end

  def show_cards(account, first_message, second_message, exit_message)
    return unless card_exist?(account)

    puts I18n.t(first_message)

    account.cards.each_with_index do |card, index|
      puts I18n.t(second_message, card_number: card.number, card_type: card.type, index: index + 1)
    end
    puts I18n.t(exit_message)
    take_card_number(@account)
  end

  def card_exist?(account)
    return true if account.cards.any?

    puts I18n.t('card.no_cards')
    false
  end
end
