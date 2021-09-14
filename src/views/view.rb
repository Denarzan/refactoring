module View
  class << self
    def sign_in_error
      puts I18n.t('sign_in.error')
    end

    def sign_in_login
      puts I18n.t('sign_in.login')
    end

    def sign_in_password
      puts I18n.t('sign_in.password')
    end

    def registration_name
      puts I18n.t('registration.name')
    end

    def registration_login
      puts I18n.t('registration.login')
    end

    def registration_age
      puts I18n.t('registration.age')
    end

    def registration_password
      puts I18n.t('registration.password')
    end

    def menu_start(name)
      puts I18n.t('menu.start', name: name)
    end

    def menu_wrong_command
      puts I18n.t('menu.wrong_command')
    end

    def delete_account
      puts I18n.t('delete_account')
    end

    def no_active_accounts
      puts I18n.t('registration.no_active_accounts')
    end

    def show_card(number, type)
      puts "- #{number}, #{type}"
    end

    def card_delete(number)
      puts I18n.t('card.delete.sure?', card: number)
    end

    def card_wrong_type
      puts I18n.t('card.wrong_type')
    end

    def card_wrong
      puts I18n.t('card.wrong')
    end

    def puts_message(message)
      puts I18n.t(message)
    end

    def puts_cards(message, card, index)
      puts I18n.t(message, card_number: card.number, card_type: card.type, index: index + 1)
    end

    def no_cards
      puts I18n.t('card.no_cards')
    end

    def withdraw_success(card, amount)
      puts I18n.t('card.withdraw.success', amount: amount, card: card.number,
                                           money_left: card.balance, tax: card.withdraw_tax(amount.to_i))
    end

    def puts_money_success(card, amount)
      puts I18n.t('card.put_money.success', amount: amount, card_number: card.number,
                                            balance: card.balance, tax: card.put_tax(amount.to_i))
    end

    def send_money_success(recipient_card, sender_card, amount)
      puts I18n.t('card.send_money.success', amount: amount, card_number: recipient_card.number,
                                             balance: sender_card.balance, tax: sender_card.sender_tax(amount.to_i))
      puts I18n.t('card.send_money.success', amount: amount, card_number: recipient_card.number,
                                             balance: recipient_card.balance, tax: recipient_card.put_tax(amount.to_i))
    end

    def withdraw_ammount
      puts I18n.t('card.withdraw.amount')
    end

    def put_money_amount
      puts I18n.t('card.put_money.amount')
    end

    def withdraw_amount
      puts I18n.t('card.withdraw.amount')
    end

    def withdraw_no_enough
      puts I18n.t('card.withdraw.no_enough')
    end

    def put_money_no_enough
      puts I18n.t('card.put_money.no_enough')
    end

    def send_money_no_enough
      puts I18n.t('card.send_money.no_enough')
    end

    def incorrect_card
      puts I18n.t('card.incorrect')
    end

    def recipient_card
      I18n.t('card.send_money.recipient_card')
    end

    def no_card_to_send(card_number)
      puts I18n.t('card.send_money.no_card', card_number: card_number)
    end

    def incorrect_number_to_send
      puts I18n.t('card.send_money.incorrect_number')
    end
  end
end
