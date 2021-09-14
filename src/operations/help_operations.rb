module HelpOperations
  include Input
  include Output

  private

  def take_card_number(account)
    input = fetch_input
    return if input == 'exit'

    card = account.find_card(input)
    if card.nil?
      View.card_wrong
      take_card_number(account)
    end
    card
  end

  def show_cards(account, first_message, second_message, exit_message)
    return unless card_exist?(account)

    View.puts_message(first_message)

    account.cards.each_with_index do |card, index|
      View.puts_cards(second_message, card, index)
    end
    View.puts_message(exit_message)
    take_card_number(@account)
  end

  def card_exist?(account)
    return true if account.cards.any?

    View.no_cards
    false
  end
end
