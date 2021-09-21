module HelpView
  def check_cards(account, chose_card)
    return :no_cards unless show_user_cards(account, chose_card, 'card.show_cards', 'card.exit')

    input = fetch_input
    return :exit if input == 'exit'

    card = account.find_card(input)
    return card unless card.nil?

    Output.card_wrong
    :card_wrong
  end

  def show_user_cards(account, first_message, second_message, exit_message)
    return false unless card_exist?(account)

    Output.puts_message(first_message)

    account.cards.each_with_index do |card, index|
      Output.puts_cards(second_message, card, index)
    end
    Output.puts_message(exit_message)
    true
  end
end
