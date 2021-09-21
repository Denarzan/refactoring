module PutsMoneyOutput
  def puts_money_success(card, amount)
    puts I18n.t('card.put_money.success', amount: amount, card_number: card.number,
                                          balance: card.balance, tax: card.put_tax(amount.to_i))
  end

  def put_money_amount
    puts I18n.t('card.put_money.amount')
  end

  def put_money_no_enough
    puts I18n.t('card.put_money.no_enough')
  end
end
