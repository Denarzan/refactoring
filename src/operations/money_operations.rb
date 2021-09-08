require 'i18n'
require_relative '../help_methods/input'
require_relative '../help_methods/output'
require_relative '../cards/card'
require_relative 'help_operations'

class MoneyOperations
  include HelpOperations

  def initialize(storage, account)
    @storage = storage
    @account = account
  end

  def withdraw_money_operation
    return unless card_exist?(@account)

    card = show_cards(@account, 'card.withdraw.chose', 'card.show_cards', 'card.exit')
    return if card.nil?

    amount = withdraw_amount(card)
    return if amount.nil?

    withdraw_money(card, amount)
  end

  def put_money_operation
    return unless card_exist?(@account)

    card = show_cards(@account, 'card.put_money.chose', 'card.show_cards', 'card.exit')
    return if card.nil?

    amount = put_money_amount(card)
    return if amount.nil?

    put_money(card, amount)
  end

  def send_money_operation
    return unless card_exist?(@account)

    sender_card = show_cards(@account, 'card.send_money.chose', 'card.show_cards', 'card.exit')
    return if sender_card.nil?

    recipient_card = find_recipient_card
    return if recipient_card.nil?

    amount = send_money_amount(recipient_card, sender_card)
    return if amount.nil?

    send_money(recipient_card, sender_card, amount)
  end

  private

  def withdraw_money(card, amount)
    card.withdraw_money(amount.to_i)
    @storage.save_accounts
    puts I18n.t('card.withdraw.success', amount: amount, card: card.number,
                                         money_left: card.balance, tax: card.withdraw_tax(amount.to_i))
  end

  def put_money(card, amount)
    card.put_money(amount.to_i)
    @storage.save_accounts
    puts I18n.t('card.put_money.success', amount: amount, card_number: card.number,
                                          balance: card.balance, tax: card.put_tax(amount.to_i))
  end

  def send_money(recipient_card, sender_card, amount)
    sender_card.send_money(amount.to_i)
    recipient_card.put_money(amount.to_i)
    @storage.save_accounts
    puts I18n.t('card.send_money.success', amount: amount, card_number: recipient_card.number,
                                           balance: sender_card.balance, tax: sender_card.sender_tax(amount.to_i))
    puts I18n.t('card.send_money.success', amount: amount, card_number: recipient_card.number,
                                           balance: recipient_card.balance, tax: recipient_card.put_tax(amount.to_i))
  end

  def withdraw_amount(card)
    amount = get_input(I18n.t('card.withdraw.amount'))
    positive_amount?(amount) && money_enough_for_withdraw?(card, amount) ? amount : nil
  end

  def put_money_amount(card)
    amount = get_input(I18n.t('card.put_money.amount'))
    positive_amount?(amount) && money_enough_for_put?(card, amount) ? amount : nil
  end

  def send_money_amount(recipient_card, sender_card)
    amount = get_input(I18n.t('card.withdraw.amount'))
    send_money_amount(recipient_card, sender_card) unless can_send?(recipient_card, sender_card, amount)

    amount
  end

  def money_enough_for_withdraw?(card, amount)
    return true if card.withdraw_money?(amount.to_i)

    puts I18n.t('card.withdraw.not_enough')
    false
  end

  def money_enough_for_put?(card, amount)
    return true if card.put_money?(amount.to_i)

    puts I18n.t('card.put_money.no_enough')
    false
  end

  def money_enough_for_send?(card, amount)
    return true if card.send_money?(amount.to_i)

    puts I18n.t('card.send_money.no_money')
    false
  end

  def positive_amount?(amount)
    return true if amount.to_i.positive?

    puts I18n.t('card.incorrect')
    false
  end

  def can_send?(recipient_card, sender_card, amount)
    positive_amount?(amount) && money_enough_for_put?(recipient_card, amount) &&
      money_enough_for_send?(sender_card, amount)
  end

  def find_recipient_card
    card_number = get_input(I18n.t('card.send_money.recipient_card'))
    if card_number.length == 16
      found_card = @storage.accounts.map(&:cards).flatten.detect { |card| card.number == card_number }
      return found_card unless found_card.nil?

      puts I18n.t('card.send_money.no_card', card_number: card_number)
      find_recipient_card
    else puts I18n.t('card.send_money.incorrect_number')
    end
  end
end
