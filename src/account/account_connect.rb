class AccountConnect
  attr_reader :current_account, :storage, :card_operations, :money_operations

  COMMANDS = {
    'SC' => :show_cards,
    'CC' => :create_card,
    'DC' => :destroy_card,
    'PM' => :put_money,
    'WM' => :withdraw_money,
    'SM' => :send_money,
    'DA' => :destroy_account,
    'exit' => :shutdown
  }.freeze

  def initialize
    @storage = Storage.new
  end

  def create(name, login, age, password)
    registration = AccountRegistration.new(@storage, name, login, age, password)
    data = registration.create_account
    return data if data[0].nil?

    @current_account = Account.new(*data)
    @storage.add_account(@current_account)
    ['good', create_operations]
  end

  def load(login, password)
    account = AccountLogin.new(@storage)
    @current_account = account.sign_in(login, password)
    return if @current_account.nil?

    create_operations
  end

  def chose_command(user_input)
    COMMANDS.include?(user_input) ? COMMANDS[user_input] : nil
  end

  def no_accounts?
    @storage.accounts.none?
  end

  private

  def create_operations
    @card_operations = CardOperations.new(@storage, @current_account)
    @money_operations = MoneyOperations.new(@storage, @current_account)
  end
end
