require_relative '../help_methods/input'
class AccountLogin
  include Input
  def initialize(storage)
    @storage = storage
  end

  def sign_in
    data = credentials
    if @storage.find_account?(data[:login], data[:password])
      @storage.accounts.detect { |a| data[:login] == a.login && data[:password] == a.password }
    else
      puts I18n.t('sign_in.error')
      sign_in
    end
  end

  def credentials
    login = get_input(I18n.t('sign_in.login'))
    password = get_input(I18n.t('sign_in.password'))
    { login: login, password: password }
  end
end
