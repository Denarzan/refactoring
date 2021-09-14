require_relative '../help_methods/input'
require_relative '../help_methods/output'
require_relative '../account/account'
require_relative '../storage/storage'
require_relative '../account/account_login'
require_relative '../account/account_registration'
require_relative '../operations/money_operations'
require_relative '../operations/card_operations'
require 'i18n'

class Console
  include Input
  include Output
  attr_reader :current_account

  COMMANDS = {
    'SC' => :show_cards,
    'CC' => :create_card,
    'DC' => :destroy_card,
    'PM' => :put_money,
    'WM' => :withdraw_money,
    'SM' => :send_money,
    'DA' => :destroy_account,
    'exit' => :exit
  }.freeze

  def initialize
    @storage = Storage.new
  end

  def console
    multiline_output('console')
    case fetch_input
    when 'create' then create
    when 'load' then load
    else exit
    end
  end

  def create
    registration = AccountRegistration.new(@storage)
    data = registration.create_account
    @current_account = Account.new(*data)
    @storage.add_account(@current_account)
    create_operations
    main_menu
  end

  def load
    return create_the_first_account if @storage.accounts.none?

    login = AccountLogin.new(@storage)
    @current_account = login.sign_in
    create_operations
    main_menu
  end

  def main_menu
    loop do
      View.menu_start(@current_account.name)
      command = fetch_input
      if COMMANDS.include?(command)
        send(COMMANDS[command])
      else
        View.menu_wrong_command
      end
    end
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
    View.delete_account
    answer = fetch_input
    @storage.delete_account(@current_account) if answer == 'y'
    exit
  end

  def put_money
    @money_operations.put_money_operation
  end

  def send_money
    @money_operations.send_money_operation
  end

  def create_the_first_account
    View.no_active_accounts
    fetch_input == 'y' ? create : console
  end

  private

  def create_operations
    @card_operations = CardOperations.new(@storage, @current_account)
    @money_operations = MoneyOperations.new(@storage, @current_account)
  end
end
