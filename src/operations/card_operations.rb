require 'i18n'
require_relative '../help_methods/input'
require_relative '../help_methods/output'
require_relative '../cards/card'
require_relative 'help_operations'

CARD_TYPES = %w[usual capitalist virtual].freeze
class CardOperations
  include HelpOperations

  def initialize(storage, account)
    @storage = storage
    @account = account
  end

  def create_card_operation
    loop do
      multiline_output(I18n.t('card.create'))
      card_type = get_input

      if CARD_TYPES.include?(card_type)
        @account.add_card(Card.new(card_type))
        @storage.save_accounts
      else
        puts I18n.t('card.wrong_type')
      end
    end
  end

  def destroy_card_operation
    show_cards(@account, 'card.delete.offer', 'card.show_cards', 'card.exit')
    card = take_card_number(@account)
    return if card.nil?

    delete_card(card) if sure_to_delete_card?(card)
  end

  def show_cards_operation
    return unless card_exist?

    @account.cards.each do |card|
      puts "- #{card.number}, #{card.type}"
    end
  end

  private

  def sure_to_delete_card?(card)
    get_input(I18n.t('card.delete.sure?', card: card.number)) == 'y'
  end

  def delete_card(index)
    @account.remove_card(index)
    @storage.save_accounts
    true
  end
end
