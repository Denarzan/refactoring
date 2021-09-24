class PutMoneyView < HelpView
  def put_money_module(account_operations)
    card = check_cards(account_operations.current_account, 'card.put_money.chose')
    case card
    when :no_cards then Output.no_cards
    when :exit then nil
    when :wrong_card then put_money(account_operations)
    else put_money_operation(card, account_operations)
    end
  end

  private

  def put_money_operation(card, account_operations)
    Output.put_money_amount
    amount = fetch_input
    status = account_operations.money_operations.put_money_operation(card, amount)
    case status
    when :bad_input then Output.incorrect_card
    when :no_money then Output.put_money_no_enough
    else Output.puts_money_success(card, amount)
    end
  end
end
