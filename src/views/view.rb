class View
  include Input
  include Output
  include HelpView
  include HelpOperations
  include SendMoneyView
  include WithdrawMoneyView
  include PutMoneyView

  def initialize
    @account_operations = AccountConnect.new
  end

  def start
    Output.multiline_output('console')
    case fetch_input
    when 'create' then fetch_account('create')
    when 'load' then fetch_account('load')
    else exit
    end
  end

  def call_main_menu
    Output.menu_start(@account_operations.current_account.name)
    user_input = fetch_input
    command = @account_operations.chose_command(user_input)
    command.nil? ? Output.menu_wrong_command : send(command)
    call_main_menu
  end

  private

  def create_card
    Output.multiline_output('card.create')
    card_type = fetch_input
    return if card_type == 'exit'

    @account_operations.card_operations.create_card_operation?(card_type) ? return : Output.card_wrong_type

    create_card
  end

  def destroy_card
    show_user_cards(@account_operations.current_account, 'card.delete.offer', 'card.show_cards', 'card.exit') ? true : return
    input = fetch_input
    return if input == 'exit'

    card = @account_operations.current_account.find_card(input)
    if card.nil?
      Output.card_wrong
      return destroy_card
    end
    @account_operations.card_operations.destroy_card_operation(card) if sure_to_delete_card?(card)
  end

  def show_cards
    cards = @account_operations.card_operations.show_cards_operation
    return Output.no_cards if cards.nil?

    cards.each do |card|
      Output.show_card(card.number, card.type)
    end
  end

  def destroy_account
    Output.delete_account
    answer = fetch_input
    @account_operations.storage.delete_account(@account_operations.current_account) if answer == 'y'
    exit
  end

  def put_money
    put_money_module(@account_operations)
  end

  def send_money
    send_money_module(@account_operations)
  end

  def withdraw_money
    withdraw_money_module(@account_operations)
  end

  def fetch_account(command)
    command == 'create' ? create_account : load_account
    call_main_menu
  end

  def create_account
    data = @account_operations.create(name_input, login_input, age_input, password_input)
    return unless data[0].nil?

    # print data.inspect
    data.delete_at(0)
    # print data.inspect

    data.each { |error| puts error }
    create_account
  end

  def name_input
    Output.registration_name
    fetch_input
  end

  def login_input
    Output.registration_login
    fetch_input
  end

  def age_input
    Output.registration_age
    fetch_input
  end

  def password_input
    Output.registration_password
    fetch_input
  end

  def load_account
    return create_the_first_account if @account_operations.no_accounts?

    Output.sign_in_login
    login = fetch_input
    Output.sign_in_password
    password = fetch_input
    load_account if @account_operations.load(login, password).nil?
  end

  def create_the_first_account
    Output.no_active_accounts
    fetch_input == 'y' ? create_account : start
  end

  def sure_to_delete_card?(card)
    Output.card_delete(card.number)
    fetch_input == 'y'
  end
end
