class CreateCardView < BaseView
  def create_card_module(account_operations)
    Output.multiline_output('card.create')
    card_type = fetch_input
    return if card_type == 'exit'

    account_operations.card_operations.create_card_operation?(card_type) ? return : Output.card_wrong_type

    create_card_module(account_operations)
  end
end
