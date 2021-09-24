module Banking
  class Storage
    FILE = 'accounts.yml'.freeze
    attr_accessor :accounts

    def initialize
      @accounts = load_storage_file
    end

    def load_storage_file
      return [] unless File.exist?(FILE)

      YAML.load_file(FILE) || []
    end

    def add_account(account)
      @accounts << account
      save_accounts
    end

    def save_accounts
      File.open(FILE, 'w') { |f| f.write @accounts.to_yaml }
    end

    def find_account?(login, password)
      @accounts.map { |a| { login: a.login, password: a.password } }.include?({ login: login, password: password })
    end

    def delete_account(account)
      @accounts.delete(account)
      save_accounts
    end
  end
end
