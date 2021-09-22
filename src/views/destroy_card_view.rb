class DestroyCardView < BaseView

  def destroy_card_module(account_operations)
    show_user_cards(account_operations.current_account, 'card.delete.offer', 'card.show_cards', 'card.exit') ? true : return
    input = fetch_input
    return if input == 'exit'

    card = account_operations.current_account.find_card(input)
    if card.nil?
      Output.card_wrong
      return destroy_card_module(account_operations)
    end
    account_operations.card_operations.destroy_card_operation(card) if sure_to_delete_card?(card)
  end
end
