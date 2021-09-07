require_relative 'help_methods/input'
require_relative 'help_methods/output'
require_relative 'account/account'
require_relative 'storage'
require_relative 'account/account_login'
require_relative 'account/account_registration'
require 'i18n'

COMMANDS = { 'SC': :show_cards,
             'CC': :create_card,
             'DC': :destroy_card,
             'PM': :put_money,
             'WM': :withdraw_money,
             'SM': :send_money,
             'DA': :destroy_account }.freeze
class Console
  include Input
  include Output

  def initialize
    @storage = Storage.new
  end

  def console
    multiline_output('console')
    case get_input
    when 'create' then create
    when 'load' then load
    else exit
    end
  end

  def create
    registration = AccountRegistration.new
    @current_account = Account.new(*registration)
    @storage.add_account(@current_account)
    main_menu
  end

  def load
    return create_the_first_account if @storage.accounts.none?

    @current_account = AccountLogin(@storage)
    main_menu
  end

  def main_menu
    loop do
      multiline_output(I18n.t('menu.start', name: @current_account.name))
      command = get_input
      exit if command == 'exit'
      return public_send(COMMANDS[command]) if COMMANDS.include?(command)

      puts I18n.t('menu.wrong_command')
    end
  end

  private

  def create_the_first_account
    get_input(I18n.t('account.no_active_accounts')) == 'y' ? create : console
  end

  def create_operations
    @card_operations = CardOperations.new(@storage, @current_account)
    @money_operations = MoneyOperations.new(@storage, @current_account)
  end

  def create_card
    @card_operations.create_card_operation
  end

  def destroy_card
    @card_operations.destroy_card_operation
  end

  def show_cards
    @card_operations.show_cards_operation
  end

  def withdraw_money
    @money_operations.withdraw_money_operation
  end

  def destroy_account
    answer = get_input(I18n.t('delete_account'))
    @storage.delete_account(@current_account) if answer == 'y'
    exit
  end

  def put_money
    @money_operations.put_money_operation
  end

  def send_money
    @money_operations.send_money_operation
  end
end
