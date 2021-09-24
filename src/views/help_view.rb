module Banking
  module View
    class HelpView
      include HelpOperations
      include Input

      private

      def check_cards(account, chose_card_message)
        return :no_cards unless show_user_cards(account, chose_card_message)

        input = fetch_input
        return :exit if input == 'exit'

        card = account.find_card(input)
        return card unless card.nil?

        Output.card_wrong
        :card_wrong
      end

      def show_user_cards(account, chose_card_message)
        return false unless card_exist?(account)

        Output.puts_message(chose_card_message)

        account.cards.each_with_index do |card, index|
          Output.puts_cards('card.show_cards', card, index)
        end
        Output.puts_message('card.exit')
        true
      end

      def sure_to_delete_card?(card)
        Output.card_delete(card.number)
        fetch_input == 'y'
      end
    end
  end
end
