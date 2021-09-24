module Banking
  module Views
    class DestroyAccountView < HelpView
      def destroy_account_module(account_operations)
        Output.delete_account
        answer = fetch_input
        account_operations.storage.delete_account(account_operations.current_account) if answer == 'y'
      end
    end
  end
end
