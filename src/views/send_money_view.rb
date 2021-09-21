module SendMoneyView
  def send_money_module(account_operations)
    sender_card = check_cards(account_operations.current_account, 'card.withdraw.chose')
    case sender_card
    when :no_cards then Output.no_cards
    when :exit then exit
    when :wrong_card then put_money(account_operations)
    else take_recipient_card(account_operations, sender_card)
    end
  end

  private

  def take_recipient_card(account_operations, sender_card)
    recipient_card = find_recipient_card(account_operations)
    return if recipient_card.nil?

    send_money_operation(account_operations, sender_card, recipient_card)
  end

  def send_money_operation(account_operations, sender_card, recipient_card)
    Output.withdraw_amount
    amount = fetch_input
    status = account_operations.money_operations.send_money_operation(sender_card, recipient_card, amount)
    case status
    when :bad_input then Output.incorrect_card
    when :no_money_recipient then Output.put_money_no_enough
    when :no_money_sender then Output.send_money_no_enough
    else return Output.send_money_success(recipient_card, sender_card, amount)
    end
    send_money_operation(account_operations, sender_card, recipient_card)
  end

  def find_recipient_card(account_operations)
    Output.recipient_card
    card_number = fetch_input
    found_card = account_operations.money_operations.find_recipient_card_operation(card_number)
    case found_card
    when :incorrect_number then Output.incorrect_number_to_send
    when :no_card then Output.no_card_to_send(card_number)
    else return found_card
    end
    nil
  end
end
