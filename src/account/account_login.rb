require_relative '../help_methods/input'
class AccountLogin
  include Input
  def initialize(storage)
    @storage = storage
    sign_in
  end

  def sign_in
    if @storage.accounts.find_account?(*credentials)
      @accounts.select { |a| login == a.login }.first
    else
      puts I18n.t('sign_in.error')
      sign_in
    end

  end

  def credentials
    login = get_input(I18n.t('sign_in.login'))
    password = get_input(I18n.t('sign_in.password'))
    [login, password]
  end
end
