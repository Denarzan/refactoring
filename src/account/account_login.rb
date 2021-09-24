module Banking
  module Account
    class AccountLogin
      def initialize(storage)
        @storage = storage
      end

      def sign_in(login, password)
        return unless @storage.find_account?(login, password)

        @storage.accounts.detect { |a| login == a.login && password == a.password }
      end
    end
  end
end
