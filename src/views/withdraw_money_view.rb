module WithdrawMoneyView
  def withdraw_money_module(account_operations)
    card = check_cards(account_operations.current_account, 'card.withdraw.chose')
    case card
    when :no_cards then Output.no_cards
    when :exit then exit
    when :wrong_card then withdraw_money(account_operations)
    else withdraw_operation(card, account_operations)
    end
  end

  private

  def withdraw_operation(card, account_operations)
    Output.withdraw_amount
    amount = fetch_input
    status = account_operations.money_operations.withdraw_money_operation(card, amount)
    case status
    when :bad_input then Output.incorrect_card
    when :no_money then Output.withdraw_no_enough
    else Output.withdraw_success(card, amount)
    end
  end
end
