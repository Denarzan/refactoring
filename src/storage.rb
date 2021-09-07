require 'yaml'
class Storage

  def initialize
    @accounts = load_storage_file
  end

  def load_storage_file
    return [] unless File.exist?('accounts.yml')

    YAML.load_file('accounts.yml')
  end

  def add_account(account)
    @accounts << account
    save_accounts
  end

  def save_accounts
    File.open('accounts.yml', 'w') { |f| f.write @accounts.to_yaml }
  end

  def find_account?(login, password)
    @accounts.map { |a| { login: a.login, password: a.password } }.include?({ login: login, password: password })
  end

  def delete_account(account)
    @accounts.delete(account)
    save_accounts
  end
end
