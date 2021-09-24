module Banking
  module Output
    class << self
      include SignInOutput
      include RegistrationOutput
      include SendMoneyOutput
      include WithdrawOutput
      include PutsMoneyOutput

      def multiline_output(key)
        I18n.t(key).split("\n").each { |line| puts line }
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

      def incorrect_card
        puts I18n.t('card.incorrect')
      end

      def recipient_card
        puts I18n.t('card.send_money.recipient_card')
      end

      def no_card_to_send(card_number)
        puts I18n.t('card.send_money.no_card', card_number: card_number)
      end

      def incorrect_number_to_send
        puts I18n.t('card.send_money.incorrect_number')
      end
    end
  end
end
