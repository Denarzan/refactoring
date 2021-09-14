require 'i18n'
require_relative '../help_methods/input'
require_relative '../help_methods/output'
require_relative '../cards/card'
require_relative '../cards/usual_card'
require_relative '../cards/capitalist_card'
require_relative '../cards/virtual_card'
require_relative 'help_operations'

CARD_TYPES = %w[usual capitalist virtual].freeze
class CardOperations
  include HelpOperations
  include Output

  def initialize(storage, account)
    @storage = storage
    @account = account
  end

  def create_card_operation
    loop do
      multiline_output('card.create')
      card_type = fetch_input
      return if card_type == 'exit'

      create_card?(card_type) ? break : next
    end
  end

  def destroy_card_operation
    card = show_cards(@account, 'card.delete.offer', 'card.show_cards', 'card.exit')

    return if card.nil?

    delete_card(card) if sure_to_delete_card?(card)
  end

  def show_cards_operation
    return unless card_exist?(@account)

    @account.cards.each do |card|
      View.show_card(card.number, card.type)
    end
  end

  private

  def sure_to_delete_card?(card)
    View.card_delete(card.number)
    fetch_input == 'y'
  end

  def delete_card(index)
    @account.remove_card(index)
    @storage.save_accounts
    true
  end

  def chose_type(card_type)
    case card_type
    when 'usual' then @account.add_card(UsualCard.new)
    when 'capitalist' then @account.add_card(CapitalistCard.new)
    when 'virtual' then @account.add_card(VirtualCard.new)
    else
      false
    end
  end

  def create_card?(card_type)
    if CARD_TYPES.include?(card_type)
      chose_type(card_type)
      @storage.save_accounts
      true
    else
      View.card_wrong_type
      false
    end
  end
end
