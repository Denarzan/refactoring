module Banking
  class MoneyOperations
    include HelpOperations

    def initialize(storage, account)
      @storage = storage
      @account = account
    end

    def withdraw_money_operation(card, amount)
      enough_money = withdraw_amount(card, amount)
      case enough_money
      when :bad_input then :bad_input
      when :no_money then :no_money
      else
        withdraw_money(card, amount)
        true
      end
    end

    def put_money_operation(card, amount)
      enough_money = put_money_amount(card, amount)
      case enough_money
      when :bad_input then :bad_input
      when :no_money then :no_money
      else
        put_money(card, amount)
        true
      end
    end

    def send_money_operation(recipient_card, sender_card, amount)
      enough_money = can_send(recipient_card, sender_card, amount)
      case enough_money
      when :bad_input then :bad_input
      when :no_money_recipient then :no_money_recipient
      when :no_money_sender then :no_money_sender
      else
        send_money(recipient_card, sender_card, enough_money)
        true
      end
    end

    def find_recipient_card_operation(card_number)
      if card_number.length == 16
        found_card = @storage.accounts.map(&:cards).flatten.detect { |card| card.number == card_number }
        return found_card unless found_card.nil?

        :no_card
      else :incorrect_number
      end
    end

    private

    def withdraw_money(card, amount)
      card.withdraw_money(amount.to_i)
      @storage.save_accounts
    end

    def put_money(card, amount)
      card.put_money(amount.to_i)
      @storage.save_accounts
    end

    def send_money(recipient_card, sender_card, amount)
      sender_card.send_money(amount.to_i)
      recipient_card.put_money(amount.to_i)
      @storage.save_accounts
    end

    def withdraw_amount(card, amount)
      return :bad_input unless positive_amount?(amount)
      return :no_money unless money_enough_for_withdraw?(card, amount)

      amount
    end

    def put_money_amount(card, amount)
      return :bad_input unless positive_amount?(amount)
      return :no_money unless money_enough_for_put?(card, amount)

      amount
    end

    def money_enough_for_withdraw?(card, amount)
      return true if card.withdraw_money?(amount.to_i)

      false
    end

    def money_enough_for_put?(card, amount)
      return true if card.put_money?(amount.to_i)

      false
    end

    def money_enough_for_send?(card, amount)
      return true if card.send_money?(amount.to_i)

      false
    end

    def positive_amount?(amount)
      return true if amount.to_i.positive?

      false
    end

    def can_send(recipient_card, sender_card, amount)
      return :bad_input unless positive_amount?(amount)
      return :no_money_recipient unless money_enough_for_put?(recipient_card, amount)
      return :no_money_sender unless money_enough_for_send?(sender_card, amount)

      amount
    end
  end
end
