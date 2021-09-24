module Banking
  module WithdrawOutput
    def withdraw_success(card, amount)
      puts I18n.t('card.withdraw.success', amount: amount, card: card.number,
                                           money_left: card.balance, tax: card.withdraw_tax(amount.to_i))
    end

    def withdraw_amount
      puts I18n.t('card.withdraw.amount')
    end

    def withdraw_no_enough
      puts I18n.t('card.withdraw.no_enough')
    end
  end
end
