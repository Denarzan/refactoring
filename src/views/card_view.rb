class CardView < HelpView
  def create_card_module(account_operations)
    Output.multiline_output('card.create')
    card_type = fetch_input
    return if card_type == 'exit'

    account_operations.card_operations.create_card_operation?(card_type) ? return : Output.card_wrong_type

    create_card_module(account_operations)
  end

  def destroy_card_module(account_operations)
    return Output.no_cards unless show_user_cards(account_operations.current_account, 'card.delete.offer')

    input = fetch_input
    return if input == 'exit'

    confirm_destroy(account_operations, input)
  end

  def show_cards_module(account_operations)
    cards = account_operations.card_operations.show_cards_operation
    return Output.no_cards if cards.nil?

    cards.each do |card|
      Output.show_card(card.number, card.type)
    end
  end

  private

  def confirm_destroy(account_operations, input)
    card = account_operations.current_account.find_card(input)
    return not_correct_card(account_operations) if card.nil?

    account_operations.card_operations.destroy_card_operation(card) if sure_to_delete_card?(card)
  end

  def not_correct_card(account_operations)
    Output.card_wrong
    destroy_card_module(account_operations)
  end
end
