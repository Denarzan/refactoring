class View
  include Input
  include Output

  START_STATES = { create: :create_account,
                   load: :load_account }.freeze

  def initialize(state = :start)
    @account_operations = AccountConnect.new
    @state = state
  end

  def run
    loop do
      @state == :shutdown ? break : send(@state)
    end
  end

  def start
    Output.multiline_output('console')
    input_sym = fetch_input.to_sym
    return @state = START_STATES[input_sym] if START_STATES.include?(input_sym)

    @state = :shutdown
  end

  def call_main_menu
    Output.menu_start(@account_operations.current_account.name)
    user_input = fetch_input
    command = @account_operations.chose_command(user_input)
    command.nil? ? Output.menu_wrong_command : @state = command
  end

  private

  def create_card
    CardView.new.create_card_module(@account_operations)
    @state = :call_main_menu
  end

  def destroy_card
    CardView.new.destroy_card_module(@account_operations)
    @state = :call_main_menu
  end

  def show_cards
    CardView.new.show_cards_module(@account_operations)
    @state = :call_main_menu
  end

  def destroy_account
    DestroyAccountView.new.destroy_account_module(@account_operations)
    @state = :shutdown
  end

  def put_money
    PutMoneyView.new.put_money_module(@account_operations)
    @state = :call_main_menu
  end

  def send_money
    SendMoneyView.new.send_money_module(@account_operations)
    @state = :call_main_menu
  end

  def withdraw_money
    WithdrawMoneyView.new.withdraw_money_module(@account_operations)
    @state = :call_main_menu
  end

  def create_account
    data = @account_operations.create(name_input, login_input, age_input, password_input)
    return @state = :call_main_menu unless data[0].nil?

    data.delete_at(0)
    data.each { |error| puts error }
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
    return @state = :create_the_first_account if @account_operations.no_accounts?

    Output.sign_in_login
    login = fetch_input
    Output.sign_in_password
    password = fetch_input
    return @state = :call_main_menu unless @account_operations.load(login, password).nil?

    Output.sign_in_error
  end

  def create_the_first_account
    Output.no_active_accounts
    @state = fetch_input == 'y' ? :create_account : :start
  end
end
