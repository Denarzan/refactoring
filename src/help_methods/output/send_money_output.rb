module SendMoneyOutput
  def send_money_success(recipient_card, sender_card, amount)
    puts I18n.t('card.withdraw.success', amount: amount, card: sender_card.number,
                                         money_left: sender_card.balance, tax: sender_card.sender_tax(amount.to_i))
    puts I18n.t('card.send_money.success', amount: amount, card_number: recipient_card.number,
                                           balance: recipient_card.balance, tax: recipient_card.put_tax(amount.to_i))
  end

  def send_money_no_enough
    puts I18n.t('card.send_money.no_enough')
  end
end
