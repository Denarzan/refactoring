RSpec.describe Banking::View::View do
  let(:current_subject) { described_class.new }
  let(:storage) { Banking::Storage.new }
  let(:account) { Banking::Account::Account.new('Name', 'login', 'test', 23) }
  let(:card_operations) { Banking::CardOperations.new(storage, account) }
  let(:money_operations) { Banking::MoneyOperations.new(storage, account) }
  let(:account_registration) { Banking::Account::AccountRegistration.new(storage, 'Name', 'login', 23, 'test') }
  let(:view) { Banking::Output }
  let(:account_connect) { Banking::Account::AccountConnect.new }
  let(:card_view) { Banking::View::CardView.new }
  let(:put_money_view) { Banking::View::PutMoneyView.new }
  let(:withdraw_money) { Banking::View::WithdrawMoneyView.new }

  before do
    stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
    allow(Banking::Account::AccountConnect).to receive(:new).and_return(account_connect)
  end

  describe '#start' do
    context 'when correct method calling' do
      after do
        current_subject.run
      end

      it 'create account if input is create' do
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('create', 'exit')
        allow(account_connect).to receive(:create).and_return('test')
        allow(account_connect).to receive_message_chain(:current_account, :name)
        expect(view).to receive(:menu_start)
      end

      it 'load account if input is load' do
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', 'exit')
        allow(account_connect).to receive(:no_accounts?).and_return(false)
        allow(account_connect).to receive(:load).and_return(true)
        allow(account_connect).to receive_message_chain(:current_account, :name)
        expect(view).to receive(:menu_start)
      end

      it 'leave app if input is exit or some another word' do
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('another')
        expect(current_subject).to receive(:loop).once
      end
    end

    context 'with correct outout' do
      it do
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('test')
        allow(current_subject).to receive(:exit)
        Helper::HELLO_PHRASES.each { |phrase| expect(view).to receive(:puts).with(phrase) }
        current_subject.start
      end
    end
  end

  describe '#create_account' do
    let(:success_name_input) { 'Denis' }
    let(:success_age_input) { '72' }
    let(:success_login_input) { 'Denis' }
    let(:success_password_input) { 'Denis1993' }
    let(:success_inputs) { [success_name_input, success_login_input, success_age_input, success_password_input] }

    context 'with success result' do
      before do
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('create', *success_inputs, 'exit')
        allow(storage).to receive(:accounts).and_return([])
      end

      after do
        File.delete(Helper::OVERRIDABLE_FILENAME) if File.exist?(Helper::OVERRIDABLE_FILENAME)
      end

      it 'with correct outout' do
        allow(File).to receive(:open)
        Helper::ASK_PHRASES.each_value { |phrase| expect(view).to receive(:puts).with(phrase) }
        Helper::ACCOUNT_VALIDATION_PHRASES.values.map(&:values).each do |phrase|
          expect(view).not_to receive(:puts).with(phrase)
        end
        current_subject.run
      end

      it 'write to file Account instance' do
        current_subject.run
        expect(File.exist?(Helper::OVERRIDABLE_FILENAME)).to be true
        accounts = YAML.load_file(Helper::OVERRIDABLE_FILENAME)
        expect(accounts).to be_a Array
        expect(accounts.size).to be 1
        accounts.map { |account| expect(account).to be_a Account::Account }
      end
    end

    context 'with errors' do
      before do
        all_inputs = current_inputs + success_inputs
        allow(File).to receive(:open)
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('create', *all_inputs, 'exit')
        allow(storage).to receive(:accounts).and_return([])
      end

      context 'with name errors' do
        context 'without small letter' do
          let(:error_input) { 'some_test_name' }
          let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:name][:first_letter] }
          let(:current_inputs) { [error_input, success_login_input, success_age_input, success_password_input] }

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end
      end

      context 'with login errors' do
        let(:current_inputs) { [success_name_input, error_input, success_age_input, success_password_input] }

        context 'when present' do
          let(:error_input) { '' }
          let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:login][:present] }

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end

        context 'when longer' do
          let(:error_input) { 'E' * 3 }
          let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:login][:longer] }

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end

        context 'when shorter' do
          let(:error_input) { 'E' * 21 }
          let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:login][:shorter] }

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end

        context 'when exists' do
          let(:error_input) { 'Denis1345' }
          let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:login][:exists] }

          before do
            allow_any_instance_of(Storage).to receive(:accounts).and_return([instance_double('Account::Account', login: error_input)])
          end

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end
      end

      context 'with age errors' do
        let(:current_inputs) { [success_name_input, success_login_input, error_input, success_password_input] }
        let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:age][:length] }

        context 'with length minimum' do
          let(:error_input) { '22' }

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end

        context 'with length maximum' do
          let(:error_input) { '91' }

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end
      end

      context 'with password errors' do
        let(:current_inputs) { [success_name_input, success_login_input, success_age_input, error_input] }

        context 'when absent' do
          let(:error_input) { '' }
          let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:password][:present] }

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end

        context 'when longer' do
          let(:error_input) { 'E' * 5 }
          let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:password][:longer] }

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end

        context 'when shorter' do
          let(:error_input) { 'E' * 31 }
          let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:password][:shorter] }

          it { expect { current_subject.run }.to output(/#{error}/).to_stdout }
        end
      end
    end
  end

  describe '#load_account' do
    context 'without active accounts' do
      it do
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', 'exit')
        allow(account_connect.instance_variable_get(:@storage)).to receive(:accounts).and_return([])
        expect(view).to receive(:no_active_accounts)
        current_subject.run
      end
    end

    context 'with active accounts' do
      let(:name) { 'Johnny' }
      let(:login) { 'Johnny' }
      let(:password) { 'johnny1' }
      let(:age) { 1 }

      before do
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', *all_inputs, 'exit')
        allow(storage).to receive(:accounts).and_return([Banking::Account::Account.new(name, login, password, age)])
        account_connect.instance_variable_set(:@storage, storage)
        storage.instance_variable_set(:@accounts, [Banking::Account::Account.new(name, login, password, age)])
      end

      context 'with correct outout' do
        let(:all_inputs) { [login, password] }

        it do
          allow(account_connect).to receive(:no_accounts?).and_return(false)
          allow(view).to receive(:multiline_output)
          allow(view).to receive(:menu_start)
          [Helper::ASK_PHRASES[:login], Helper::ASK_PHRASES[:password]].each do |phrase|
            expect(view).to receive(:puts).with(phrase)
          end
          current_subject.run
        end
      end

      context 'when account exists' do
        let(:all_inputs) { [login, password] }

        it do
          expect { current_subject.run }.not_to output(/#{Helper::ERROR_PHRASES[:user_not_exists]}/).to_stdout
        end
      end

      context 'when account doesn\t exists' do
        let(:all_inputs) { ['test', 'test', login, password] }

        it do
          expect { current_subject.run }.to output(/#{Helper::ERROR_PHRASES[:user_not_exists]}/).to_stdout
        end
      end
    end
  end

  describe '#create_the_first_account' do
    let(:cancel_input) { 'sdfsdfs' }
    let(:success_input) { 'y' }

    it 'with correct outout' do
      allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', 'exit')
      allow(view).to receive(:multiline_output)
      allow(account_connect.instance_variable_get(:@storage)).to receive(:accounts).and_return([])

      expect { current_subject.run }.to output(Helper::COMMON_PHRASES[:create_first_account]).to_stdout
    end

    it 'calls create if user inputs is y' do
      allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', success_input, 'exit')
      allow(view).to receive(:multiline_output)
      allow(account_connect).to receive_message_chain(:current_account, :name)
      allow(account_connect).to receive(:create).and_return('success')
      expect(view).to receive(:menu_start)
      current_subject.run
    end

    it 'calls console if user inputs is not y' do
      allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', cancel_input)
      expect(current_subject).to receive(:start)
      current_subject.start
    end
  end

  describe '#call_main_menu' do
    let(:name) { 'John' }
    let(:commands) do
      {
        'SC' => :show_cards,
        'CC' => :create_card,
        'DC' => :destroy_card,
        'PM' => :put_money,
        'WM' => :withdraw_money,
        'SM' => :send_money,
        'DA' => :destroy_account,
        'exit' => :shutdown
      }
    end

    context 'with correct outout' do
      before do
        allow(current_subject).to receive(:show_cards)
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('SC', 'exit')
        allow(account_connect).to receive(:current_account).and_return(instance_double('Account::Account', name: name))
      end

      it do
        expect { current_subject.call_main_menu }.to output(/Welcome, #{name}/).to_stdout
        end
      it do
        Helper::MAIN_OPERATIONS_TEXTS.each do |text|
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return('SC', 'exit')
          expect { current_subject.call_main_menu }.to output(/#{text}/).to_stdout
        end
      end
    end

    context 'when commands used' do
      let(:undefined_command) { 'undefined' }

      it 'calls specific methods on predefined commands' do
        allow(account_connect).to receive(:current_account).and_return(instance_double('Account::Account', name: name))

        commands.each do |command, method_name|
          expect(method_name).to eq(Banking::Account::AccountConnect::COMMANDS[command])
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(command)
          current_subject.call_main_menu
        end
      end

      it 'outputs incorrect message on undefined command' do
        allow(account_connect).to receive(:current_account).and_return(instance_double('Account::Account', name: name))
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return(undefined_command, 'exit')
        expect { current_subject.call_main_menu }.to output(/#{Helper::ERROR_PHRASES[:wrong_command]}/).to_stdout
      end
    end
  end

  describe '#destroy_account' do
    let(:destroy_account) { Banking::View::DestroyAccountView.new }
    let(:cancel_input) { 'sdfsdfs' }
    let(:name) { 'Petro' }
    let(:success_input) { 'y' }
    let(:correct_login) { 'test' }
    let(:fake_login) { 'test1' }
    let(:fake_login2) { 'test2' }
    let(:correct_account) { instance_double('Account::Account', login: correct_login, name: name) }
    let(:fake_account) { instance_double('Account::Account', login: fake_login) }
    let(:fake_account2) { instance_double('Account::Account', login: fake_login2) }
    let(:accounts) { [correct_account, fake_account, fake_account2] }

    after do
      File.delete(Helper::OVERRIDABLE_FILENAME) if File.exist?(Helper::OVERRIDABLE_FILENAME)
    end


    it 'with correct outout' do
      allow(account_connect).to receive(:current_account).and_return(instance_double('Account::Account', name: name))
      allow($stdin).to receive_message_chain(:gets, :chomp).and_return(success_input)
      expect { destroy_account.destroy_account_module(account_connect) }.to output(Helper::COMMON_PHRASES[:destroy_account]).to_stdout
    end

    context 'when deleting' do
      it 'deletes account if user inputs is y' do
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return(success_input)
        allow(account_connect).to receive(:storage).and_return(storage)
        storage.instance_variable_set(:@accounts, accounts)
        allow(account_connect).to receive(:current_account).and_return(correct_account)

        destroy_account.destroy_account_module(account_connect)
        expect(File.exist?(Helper::OVERRIDABLE_FILENAME)).to be true
        file_accounts = YAML.load_file(Helper::OVERRIDABLE_FILENAME)
        expect(file_accounts).to be_a Array
        expect(file_accounts.size).to be 2
      end

      it 'doesnt delete account' do
        allow(account_connect).to receive(:card_operations).and_return(card_operations)
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return(cancel_input)
        destroy_account.destroy_account_module(account_connect)

        expect(File.exist?(Helper::OVERRIDABLE_FILENAME)).to be false
      end
    end
  end

  describe '#show_cards' do
    let(:cards) { [Banking::Card::Card.new('a'), Banking::Card::Card.new('b')] }
    let(:success_name_input) { 'Denis' }
    let(:success_age_input) { '28' }
    let(:success_login_input) { 'Denis' }
    let(:success_password_input) { 'Denis1993' }
    let(:correct_account) { instance_double('Account', login: success_login_input, name: success_name_input) }
    let(:success_inputs) { [success_name_input, success_login_input, success_age_input, success_password_input] }

    after do
      File.delete(Helper::OVERRIDABLE_FILENAME) if File.exist?(Helper::OVERRIDABLE_FILENAME)
    end

    it 'display cards if there are any' do
      allow(account_connect).to receive(:card_operations).and_return(card_operations)
      allow_any_instance_of(Account::Account).to receive(:cards).and_return(cards)
      cards.each { |card| expect(view).to receive(:puts).with("- #{card.number}, #{card.type}") }

      card_view.show_cards_module(account_connect)
    end

    it 'outputs error if there are no active cards' do
      allow(account_connect).to receive(:card_operations).and_return(card_operations)
      expect(view).to receive(:puts).with(Helper::ERROR_PHRASES[:no_active_cards])

      card_view.show_cards_module(account_connect)
    end
  end

  describe '#create_card' do
    let(:test_account) { instance_double('Account::Account', cards: []) }

    context 'with correct outout' do
      it do
        Helper::CREATE_CARD_PHRASES.each { |phrase| expect(view).to receive(:puts).with(phrase) }
        allow(account_connect).to receive(:card_operations).and_return(card_operations)
        card_operations.instance_variable_set(:@account, test_account)
        allow(storage).to receive(:accounts).and_return([])
        allow(File).to receive(:open)
        allow(test_account).to receive(:add_card)

        allow($stdin).to receive_message_chain(:gets, :chomp) { 'usual' }

        card_view.create_card_module(account_connect)
      end
    end

    context 'when correct card choose' do
      after do
        File.delete(Helper::OVERRIDABLE_FILENAME) if File.exist?(Helper::OVERRIDABLE_FILENAME)
      end

      before do
        allow(account).to receive(:cards).and_return([])
        card_operations.instance_variable_set(:@account, account)
        storage.instance_variable_set(:@accounts, [account])
        account_connect.instance_variable_set(:@storage, storage)
        card_operations.instance_variable_set(:@storage, storage)
        account_connect.instance_variable_set(:@card_operations, card_operations)
      end

      Helper::CARDS.each do |card_type, card_info|
        it "create card with #{card_type} type" do
          allow($stdin).to receive_message_chain(:gets, :chomp) { card_info[:type] }

          card_view.create_card_module(account_connect)

          expect(File.exist?(Helper::OVERRIDABLE_FILENAME)).to be true
          file_accounts = YAML.load_file(Helper::OVERRIDABLE_FILENAME)
          expect(file_accounts.first.cards.first.type).to eq card_info[:type]
          expect(file_accounts.first.cards.first.balance).to eq card_info[:balance]
          expect(file_accounts.first.cards.first.number.length).to be 16
        end
      end
    end

    context 'when incorrect card choose' do
      it do
        card_operations.instance_variable_set(:@account, account)
        card_operations.instance_variable_set(:@storage, storage)
        account_connect.instance_variable_set(:@card_operations, card_operations)
        allow(File).to receive(:open)
        allow(storage).to receive(:accounts).and_return([])
        allow($stdin).to receive_message_chain(:gets, :chomp).and_return('test', 'usual')

        expect { card_view.create_card_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:wrong_card_type]}/).to_stdout
      end
    end
  end

  describe '#destroy_card' do
    context 'without cards' do
      it 'shows message about not active cards' do
        account_connect.instance_variable_set(:@current_account, instance_double('Account::Account', cards: []))
        expect { card_view.destroy_card_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:no_active_cards]}/).to_stdout
      end
    end

    context 'with cards' do
      let(:card_one) { Banking::Card::Card.new('test') }
      let(:card_two) { Banking::Card::Card.new('test2') }
      let(:fake_cards) { [card_one, card_two] }

      before do
        account_connect.instance_variable_set(:@current_account, account)
        current_subject.instance_variable_set(:@card_operations, card_operations)
      end

      context 'with correct outout' do
        it do
          allow(account).to receive(:cards) { fake_cards }
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return('exit')
          expect { card_view.destroy_card_module(account_connect) }.to output(/#{Helper::COMMON_PHRASES[:if_you_want_to_delete]}/).to_stdout
          fake_cards.each_with_index do |card, i|
            message = /- #{card.number}, #{card.type}, press #{i + 1}/
            expect { card_view.destroy_card_module(account_connect) }.to output(message).to_stdout
          end
        end
      end

      context 'when exit if first gets is exit' do
        it do
          allow(account).to receive(:cards) { fake_cards }
          account_connect.instance_variable_set(:@current_account, account)
          expect($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
          card_view.destroy_card_module(account_connect)
        end
      end

      context 'with incorrect input of card number' do
        before do
          allow(account).to receive(:cards) { fake_cards }
          # account.instance_variable_set(:@cards, fake_cards)
          account_connect.instance_variable_set(:@current_account, account)
        end

        it do
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(fake_cards.length + 1, 'exit')
          expect { card_view.destroy_card_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:wrong_number]}/).to_stdout
        end

        it do
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(-1, 'exit')
          expect { card_view.destroy_card_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:wrong_number]}/).to_stdout
        end
      end

      context 'with correct input of card number' do
        let(:accept_for_deleting) { 'y' }
        let(:reject_for_deleting) { 'asdf' }
        let(:deletable_card_number) { 1 }

        before do
          card_operations.instance_variable_set(:@storage, storage)
          account.instance_variable_set(:@cards, fake_cards)
          storage.instance_variable_set(:@accounts, [account])
          account_connect.instance_variable_set(:@current_account, account)
          account_connect.instance_variable_set(:@card_operations, card_operations)
        end

        after do
          File.delete(Helper::OVERRIDABLE_FILENAME) if File.exist?(Helper::OVERRIDABLE_FILENAME)
        end

        it 'accept deleting' do
          commands = [deletable_card_number, accept_for_deleting]
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)
          expect { card_view.destroy_card_module(account_connect) }.to change { account_connect.current_account.cards.size }.by(-1)

          expect(File.exist?(Helper::OVERRIDABLE_FILENAME)).to be true
          file_accounts = YAML.load_file(Helper::OVERRIDABLE_FILENAME)
          expect(file_accounts.first.cards).not_to include(card_one)
        end

        it 'decline deleting' do
          commands = [deletable_card_number, reject_for_deleting]
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)

          expect { card_view.destroy_card_module(account_connect) }.not_to change(account_connect.current_account.cards, :size)
        end
      end
    end
  end

  describe '#put_money' do
    context 'without cards' do
      it 'shows message about not active cards' do
        account_connect.instance_variable_set(:@current_account, instance_double('Account::Account', cards: []))
        account_connect.instance_variable_set(:@money_operations, money_operations)
        expect { put_money_view.put_money_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:no_active_cards]}/).to_stdout
      end
    end

    context 'with cards' do
      let(:card_one) { Banking::Card::Card.new('test') }
      let(:card_two) { Banking::Card::Card.new('test2') }
      let(:fake_cards) { [card_one, card_two] }

      before do
        allow(account).to receive(:cards) { fake_cards }
        account_connect.instance_variable_set(:@current_account, account)
        money_operations.instance_variable_set(:@account, account)
        account_connect.instance_variable_set(:@money_operations, money_operations)
      end

      context 'with correct outout' do
        it do
          allow($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
          expect { put_money_view.put_money_module(account_connect) }.to output(/#{Helper::COMMON_PHRASES[:choose_card]}/).to_stdout
          fake_cards.each_with_index do |card, i|
            message = /- #{card.number}, #{card.type}, press #{i + 1}/
            expect { put_money_view.put_money_module(account_connect) }.to output(message).to_stdout
          end
        end
      end

      context 'when exit if first gets is exit' do
        it do
          allow($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
          expect(put_money_view.put_money_module(account_connect)).to be_nil
        end
      end

      context 'with incorrect input of card number' do
        before do
          allow(account).to receive(:cards) { fake_cards }
          account_connect.instance_variable_set(:@current_account, account)
          money_operations.instance_variable_set(:@account, account)
          account_connect.instance_variable_set(:@money_operations, money_operations)
        end

        it do
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(fake_cards.length + 1, 'exit')
          expect { put_money_view.put_money_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:wrong_number]}/).to_stdout
        end

        it do
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(-1, 'exit')
          expect { put_money_view.put_money_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:wrong_number]}/).to_stdout
        end
      end

      context 'with correct input of card number' do
        let(:card_one) { Banking::Card::CapitalistCard.new(50.0) }
        let(:card_two) { Banking::Card::CapitalistCard.new(100.0) }
        let(:fake_cards) { [card_one, card_two] }
        let(:chosen_card_number) { 1 }
        let(:incorrect_money_amount) { -2 }
        let(:default_balance) { 50.0 }
        let(:correct_money_amount_lower_than_tax) { 5 }
        let(:correct_money_amount_greater_than_tax) { 50 }

        before do
          account.instance_variable_set(:@cards, fake_cards)
          account_connect.instance_variable_set(:@current_account, account)
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)
        end

        context 'with correct output' do
          let(:commands) { [chosen_card_number, incorrect_money_amount] }

          it do
            expect { put_money_view.put_money_module(account_connect) }.to output(/#{Helper::COMMON_PHRASES[:input_amount]}/).to_stdout
          end
        end

        context 'with amount lower then 0' do
          let(:commands) { [chosen_card_number, incorrect_money_amount] }

          it do
            expect { put_money_view.put_money_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:correct_amount]}/).to_stdout
          end
        end

        context 'with amount greater then 0' do
          context 'with tax greater than amount' do
            let(:commands) { [chosen_card_number, correct_money_amount_lower_than_tax] }

            it do
              expect { put_money_view.put_money_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:tax_higher]}/).to_stdout
            end
          end

          context 'with tax lower than amount' do
            let(:custom_cards) do
              [
                Banking::Card::UsualCard.new(default_balance),
                Banking::Card::CapitalistCard.new(default_balance),
                Banking::Card::VirtualCard.new(default_balance)
              ]
            end

            let(:commands) { [chosen_card_number, correct_money_amount_greater_than_tax] }

            after do
              File.delete(Helper::OVERRIDABLE_FILENAME) if File.exist?(Helper::OVERRIDABLE_FILENAME)
            end

            it do
              custom_cards.each do |custom_card|
                allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)
                storage.instance_variable_set(:@accounts, [account])
                account_connect.instance_variable_set(:@storage, storage)
                account.instance_variable_set(:@cards, [custom_card, card_one, card_two])
                account_connect.instance_variable_set(:@current_account, account)
                new_balance = default_balance + correct_money_amount_greater_than_tax - custom_card.put_tax(correct_money_amount_greater_than_tax)

                expect { put_money_view.put_money_module(account_connect) }.to output(
                                                          /Money #{correct_money_amount_greater_than_tax} was put on #{custom_card.number}. Balance: #{new_balance}. Tax: #{custom_card.put_tax(correct_money_amount_greater_than_tax)}/
                                                        ).to_stdout

                expect(File.exist?(Helper::OVERRIDABLE_FILENAME)).to be true
                file_accounts = YAML.load_file(Helper::OVERRIDABLE_FILENAME)
                expect(file_accounts.first.cards.first.balance).to eq(new_balance)
              end
            end
          end
        end
      end
    end
  end

  describe '#withdraw_money' do
    context 'without cards' do
      it 'shows message about not active cards' do
        account_connect.instance_variable_set(:@current_account, instance_double('Account::Account', cards: []))
        account_connect.instance_variable_set(:@money_operations, money_operations)
        expect { withdraw_money.withdraw_money_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:no_active_cards]}/).to_stdout
      end
    end

    context 'with cards' do
      let(:card_one) { Banking::Card::Card.new('test') }
      let(:card_two) { Banking::Card::Card.new('test2') }
      let(:fake_cards) { [card_one, card_two] }

      context 'with correct outout' do
        it do
          allow(account).to receive(:cards) { fake_cards }
          account_connect.instance_variable_set(:@current_account, account)
          allow($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
          account_connect.instance_variable_set(:@money_operations, money_operations)
          expect { withdraw_money.withdraw_money_module(account_connect) }.to output(/#{Helper::COMMON_PHRASES[:choose_card_withdrawing]}/).to_stdout
          fake_cards.each_with_index do |card, i|
            message = /- #{card.number}, #{card.type}, press #{i + 1}/
            expect { withdraw_money.withdraw_money_module(account_connect) }.to output(message).to_stdout
          end
        end
      end

      context 'when exit if first gets is exit' do
        it do
          allow(account).to receive(:cards) { fake_cards }
          account_connect.instance_variable_set(:@current_account, account)
          account_connect.instance_variable_set(:@money_operations, money_operations)
          allow($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
          expect(withdraw_money.withdraw_money_module(account_connect)).to be_nil

        end
      end

      context 'with incorrect input of card number' do
        before do
          allow(account).to receive(:cards) { fake_cards }
          account_connect.instance_variable_set(:@current_account, account)
          account_connect.instance_variable_set(:@money_operations, money_operations)
        end

        it do
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(fake_cards.length + 1, 'exit')
          expect { withdraw_money.withdraw_money_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:wrong_number]}/).to_stdout
        end

        it do
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(-1, 'exit')
          expect { withdraw_money.withdraw_money_module(account_connect) }.to output(/#{Helper::ERROR_PHRASES[:wrong_number]}/).to_stdout
        end
      end

      context 'with correct input of card number' do
        let(:card_one) { Banking::Card::CapitalistCard.new(50.0) }
        let(:card_two) { Banking::Card::CapitalistCard.new(100.0) }
        let(:fake_cards) { [card_one, card_two] }
        let(:chosen_card_number) { 1 }
        let(:incorrect_money_amount) { -2 }
        let(:default_balance) { 50.0 }
        let(:correct_money_amount_lower_than_tax) { 5 }
        let(:correct_money_amount_greater_than_tax) { 50 }

        before do
          account.instance_variable_set(:@cards, fake_cards)
          account_connect.instance_variable_set(:@current_account, account)
          account_connect.instance_variable_set(:@money_operations, money_operations)
          allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)
        end

        context 'with correct output' do
          let(:commands) { [chosen_card_number, incorrect_money_amount] }

          it do
            expect { withdraw_money.withdraw_money_module(account_connect) }.to output(/#{Helper::COMMON_PHRASES[:withdraw_amount]}/).to_stdout
          end
        end
      end
    end
  end
end