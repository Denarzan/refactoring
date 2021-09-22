class View
  include Input
  include Output

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
    CardView.new.create_card_module(@account_operations)
  end

  def destroy_card
    CardView.new.destroy_card_module(@account_operations)
  end

  def show_cards
    CardView.new.show_cards_module(@account_operations)
  end

  def destroy_account
    DestroyAccountView.new.destroy_account_module(@account_operations)
    exit
  end

  def put_money
    PutMoneyView.new.put_money_module(@account_operations)
  end

  def send_money
    SendMoneyView.new.send_money_module(@account_operations)
  end

  def withdraw_money
    WithdrawMoneyView.new.withdraw_money_module(@account_operations)
  end

  def fetch_account(command)
    command == 'create' ? create_account : load_account
    call_main_menu
  end

  def create_account
    data = @account_operations.create(name_input, login_input, age_input, password_input)
    return unless data[0].nil?

    data.delete_at(0)
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
    return unless @account_operations.load(login, password).nil?

    Output.sign_in_error
    load_account
  end

  def create_the_first_account
    Output.no_active_accounts
    fetch_input == 'y' ? create_account : start
  end
end
