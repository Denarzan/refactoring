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
      View.sign_in_error
      sign_in
    end
  end

  def credentials
    View.sign_in_login
    login = fetch_input
    View.sign_in_password
    password = fetch_input
    { login: login, password: password }
  end
end
