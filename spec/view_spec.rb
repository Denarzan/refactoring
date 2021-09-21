# RSpec.describe View do
#   let(:current_subject) { described_class.new }
#   let(:storage) { Storage.new }
#   let(:account) { Account.new('Name', 'login', 'test', 23) }
#   let(:card_operations) { CardOperations.new(storage, account) }
#   let(:money_operations) { MoneyOperations.new(storage, account) }
#   let(:account_registration) { AccountRegistration.new(storage, 'Name', 'login', 'test', 23) }
#   let(:view) { Output }
#   let(:account_connect) { instance_double(AccountConnect) }
#
#   before do
#     allow(AccountConnect).to receive(:new).and_return(account_connect)
#     stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#   end
#
#   describe '#start' do
#     context 'when correct method calling' do
#       before do
#         allow(current_subject).to receive(:call_main_menu)
#       end
#       after do
#         current_subject.start
#       end
#
#       it 'create account if input is create' do
#         allow($stdin).to receive_message_chain(:gets, :chomp) { 'create' }
#         expect(current_subject).to receive(:create_account)
#       end
#
#       it 'load account if input is load' do
#         allow($stdin).to receive_message_chain(:gets, :chomp).and_return( 'load')
#         expect(current_subject).to receive(:load_account)
#       end
#
#       it 'leave app if input is exit or some another word' do
#         allow($stdin).to receive_message_chain(:gets, :chomp) { 'another' }
#         expect(current_subject).to receive(:exit)
#       end
#     end
#
#     context 'with correct outout' do
#       it do
#         allow($stdin).to receive_message_chain(:gets, :chomp) { 'test' }
#         allow(current_subject).to receive(:exit)
#         Helper::HELLO_PHRASES.each { |phrase| expect(view).to receive(:puts).with(phrase) }
#         current_subject.start
#       end
#     end
#   end
#
#   describe '#create_account' do
#     let(:success_name_input) { 'Denis' }
#     let(:success_age_input) { '72' }
#     let(:success_login_input) { 'Denis' }
#     let(:success_password_input) { 'Denis1993' }
#     let(:success_inputs) { [success_name_input, success_login_input, success_password_input, success_age_input] }
#
#     context 'create new account' do
#       let(:all_inputs) { current_inputs + success_inputs }
#       after do
#         current_subject.start
#       end
#
#       context 'should call main menu' do
#         before do
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('create')
#           allow(account_connect).to receive(:create).and_return('good')
#         end
#         it 'if right input' do
#           expect(current_subject).to receive(:call_main_menu)
#         end
#       end
#
#       context 'call create_user' do
#         before do
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('create')
#           allow(account_connect).to receive(:create).and_return([nil, 'error1', 'error2'], 'good')
#         end
#         it 'if bad input' do
#           expect(current_subject).to receive(:call_main_menu)
#         end
#       end
#
#       context 'with correct outout' do
#         it do
#           allow($stdin).to receive_message_chain(:gets, :chomp) { 'create' }
#           allow(account_connect).to receive(:create).and_return('good')
#           allow(current_subject).to receive(:call_main_menu)
#           allow(view).to receive(:multiline_output)
#           Helper::ASK_PHRASES.each_value { |phrase| expect(view).to receive(:puts).with(phrase) }
#         end
#       end
#
#       context 'output errors' do
#         before do
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('create')
#           allow(account_connect).to receive(:create).and_return([nil, 'error1', 'error2'], 'good')
#           allow(current_subject).to receive(:call_main_menu)
#
#         end
#         it 'if bad input' do
#           expect(current_subject).to receive(:puts).with('error1')
#           expect(current_subject).to receive(:puts).with('error2')
#         end
#       end
#     end
#   end
#
#
#   describe '#load_account' do
#     context 'without active accounts' do
#       before do
#         allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load')
#         allow(account_connect).to receive(:no_accounts?).and_return(true)
#         allow(current_subject).to receive(:call_main_menu)
#       end
#
#       it 'should ask to create a new account'  do
#         expect(current_subject).to receive(:create_the_first_account)
#         current_subject.start
#       end
#     end
#
#     context 'with active accounts' do
#       let(:login) { 'Johnny' }
#       let(:password) { 'Johnny' }
#       let(:bad_login) { 'johnny1' }
#       let(:bad_password) { 34 }
#
#       after do
#         current_subject.start
#       end
#
#
#       context 'when data is good' do
#         let(:all_inputs) { [login, password] }
#         before do
#           stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', login, password )
#           allow(account_connect).to receive(:no_accounts?).and_return(false)
#           allow(account_connect).to receive(:load).and_return(true)
#         end
#
#         it 'should call main_menu'  do
#           expect(current_subject).to receive(:call_main_menu)
#         end
#       end
#
#       context 'with correct outout' do
#         before do
#
#           stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load')
#           allow(account_connect).to receive(:no_accounts?).and_return(false)
#           allow(account_connect).to receive(:load).and_return(true)
#           allow(view).to receive(:multiline_output)
#           allow(current_subject).to receive(:call_main_menu)
#
#         end
#         it { expect { current_subject.start }.to output(/#{Helper::ASK_PHRASES[:login]}/).to_stdout }
#         it { expect { current_subject.start }.to output(/#{Helper::ASK_PHRASES[:password]}/).to_stdout }
#
#       end
#
#       context 'when data is bad' do
#         let(:all_inputs) { [login, password] }
#         before do
#           stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', bad_login, bad_password,  login, password)
#           allow(account_connect).to receive(:no_accounts?).and_return(false)
#           allow(account_connect).to receive(:load).and_return(nil, true)
#         end
#
#         it 'should call load_account and then main_menu'  do
#           expect(current_subject).to receive(:call_main_menu)
#         end
#       end
#
#     end
#   end
#
#   describe '#create_the_first_account' do
#     context 'when no active accounts' do
#
#       context 'output correct message' do
#         before do
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', 'y')
#           allow(account_connect).to receive(:no_accounts?).and_return(true)
#           allow(current_subject).to receive(:call_main_menu)
#           allow(view).to receive(:multiline_output)
#
#         end
#
#         it 'with a proposal'  do
#           expect(current_subject).to receive(:create_account)
#           expect(view).to receive(:puts).with('There is no active accounts, do you want to be the first?[y/n]')
#           current_subject.start
#         end
#       end
#
#       context 'when input y' do
#         before do
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', 'y')
#           allow(account_connect).to receive(:no_accounts?).and_return(true)
#           allow(current_subject).to receive(:call_main_menu)
#         end
#
#         it 'should call create_account'  do
#           expect(current_subject).to receive(:create_account)
#           current_subject.start
#         end
#       end
#
#       context 'when input something else' do
#         before do
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', 'else')
#           allow(account_connect).to receive(:no_accounts?).and_return(true)
#           allow(current_subject).to receive(:call_main_menu)
#         end
#
#         it 'should call create_account'  do
#           expect(current_subject).to receive(:start)
#           current_subject.start
#         end
#       end
#     end
#   end
#
#
#   #   context 'with errors' do
#   #     let(:all_inputs) { current_inputs + success_inputs }
#   #     before do
#   #       allow(File).to receive(:open)
#   #       allow($stdin).to receive_message_chain(:gets, :chomp).and_return('create', *current_inputs)
#   #       allow(storage).to receive(:accounts).and_return([])
#   #       allow(account_connect).to receive(:create).and_return([nil, 'Your name must not be empty and starts with first upcase letter'])
#   #       allow(current_subject).to receive(:call_main_menu)
#   #     end
#   #
#   #   context 'with name errors' do
#   #     context 'without small letter' do
#   #       let(:error_input) { 'some_test_name' }
#   #       let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:name][:first_letter] }
#   #       let(:current_inputs) { [error_input, success_login_input, success_age_input, success_password_input] }
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #   end
#   #
#   #   context 'with login errors' do
#   #     let(:current_inputs) { [success_name_input, error_input, success_age_input, success_password_input] }
#   #
#   #     context 'when present' do
#   #       let(:error_input) { '' }
#   #       let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:login][:present] }
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #
#   #     context 'when longer' do
#   #       let(:error_input) { 'E' * 3 }
#   #       let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:login][:longer] }
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #
#   #     context 'when shorter' do
#   #       let(:error_input) { 'E' * 21 }
#   #       let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:login][:shorter] }
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #
#   #     context 'when exists' do
#   #       let(:error_input) { 'Denis1345' }
#   #       let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:login][:exists] }
#   #
#   #       before do
#   #         allow(storage).to receive(:accounts) { [instance_double('Account', login: error_input)] }
#   #         allow(Storage).to receive(:new).and_return(storage)
#   #       end
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #   end
#   #
#   #   context 'with age errors' do
#   #     let(:current_inputs) { [success_name_input, success_login_input, error_input, success_password_input] }
#   #     let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:age][:length] }
#   #
#   #     context 'with length minimum' do
#   #       let(:error_input) { '22' }
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #
#   #     context 'with length maximum' do
#   #       let(:error_input) { '91' }
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #   end
#   #
#   #   context 'with password errors' do
#   #     let(:current_inputs) { [success_name_input, success_login_input, success_age_input, error_input] }
#   #
#   #     context 'when absent' do
#   #       let(:error_input) { '' }
#   #       let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:password][:present] }
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #
#   #     context 'when longer' do
#   #       let(:error_input) { 'E' * 5 }
#   #       let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:password][:longer] }
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #
#   #     context 'when shorter' do
#   #       let(:error_input) { 'E' * 31 }
#   #       let(:error) { Helper::ACCOUNT_VALIDATION_PHRASES[:password][:shorter] }
#   #
#   #       it { expect { current_subject.start }.to output(/#{error}/).to_stdout }
#   #     end
#   #   end
#   # end
#
#
#   # describe '#create_the_first_account' do
#   #   let(:cancel_input) { 'sdfsdfs' }
#   #   let(:success_input) { 'y' }
#   #
#   #   it 'with correct outout' do
#   #     puts storage.accounts.inspect
#   #     stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#   #     allow(account_connect).to receive(:load)
#   #     allow(account_connect).to receive(:no_accounts?)
#   #
#   #     # allow(current_subject).to receive(:create_the_first_account).and_return(123)
#   #     allow(current_subject).to receive(:call_main_menu)
#   #     # allow(view).to receive(:multiline_output)
#   #     allow($stdin).to receive_message_chain(:gets, :chomp).and_return('load', 'n')
#   #     expect { current_subject.start }.to output(Helper::COMMON_PHRASES[:create_first_account]).to_stdout
#   #   end
#   #
#   # end
#
#   describe '#call_main_menu' do
#     let(:name) { 'John' }
#     let(:commands) do
#       {
#         'SC' => :show_cards,
#         'CC' => :create_card,
#         'DC' => :destroy_card,
#         'PM' => :put_money,
#         'WM' => :withdraw_money,
#         'SM' => :send_money,
#         'DA' => :destroy_account,
#         'exit' => :exit
#       }
#     end
#
#     context 'with correct outout' do
#       it do
#
#         allow(account_connect).to receive(:current_account).and_return(account)
#         expect(account_connect).to receive(:chose_command)
#         Helper::MAIN_OPERATIONS_TEXTS.each do |text|
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return('SC', 'exit')
#           expect { current_subject.call_main_menu }.to output(/#{text}/).to_stdout
#         end
#       end
#     end
#
#     context 'when commands used' do
#       let(:undefined_command) { 'undefined' }
#
#       it 'calls specific methods on predefined commands' do
#         current_subject.instance_variable_set(:@current_account, instance_double('Account', name: name))
#         allow(current_subject).to receive(:exit)
#
#         commands.each do |command, method_name|
#           expect(current_subject).to receive(method_name)
#           allow($stdin).to receive_message_chain(:gets, :chomp).and_return(command, 'exit')
#           current_subject.call_main_menu
#         end
#       end
#
#       it 'outputs incorrect message on undefined command' do
#         current_subject.instance_variable_set(:@current_account, instance_double('Account', name: name))
#         allow(current_subject).to receive(:loop).and_yield.and_yield
#         expect(current_subject).to receive(:exit)
#         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(undefined_command, 'exit')
#         expect { current_subject.call_main_menu }.to output(/#{Helper::ERROR_PHRASES[:wrong_command]}/).to_stdout
#       end
#     end
#   end
#   #
#   # describe '#destroy_account' do
#   #   let(:cancel_input) { 'sdfsdfs' }
#   #   let(:success_input) { 'y' }
#   #   let(:correct_login) { 'test' }
#   #   let(:fake_login) { 'test1' }
#   #   let(:fake_login2) { 'test2' }
#   #   let(:correct_account) { instance_double('Account', login: correct_login) }
#   #   let(:fake_account) { instance_double('Account', login: fake_login) }
#   #   let(:fake_account2) { instance_double('Account', login: fake_login2) }
#   #   let(:accounts) { [correct_account, fake_account, fake_account2] }
#   #
#   #   after do
#   #     File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
#   #   end
#   #
#   #   before do
#   #     allow(current_subject).to receive(:exit)
#   #   end
#   #
#   #   it 'with correct outout' do
#   #     expect($stdin).to receive_message_chain(:gets, :chomp) {}
#   #     expect { current_subject.destroy_account }.to output(COMMON_PHRASES[:destroy_account]).to_stdout
#   #   end
#   #
#   #   context 'when deleting' do
#   #     it 'deletes account if user inputs is y' do
#   #       expect($stdin).to receive_message_chain(:gets, :chomp) { success_input }
#   #       storage.instance_variable_set(:@accounts, accounts)
#   #       current_subject.instance_variable_set(:@storage, storage)
#   #       current_subject.instance_variable_set(:@current_account, correct_account)
#   #
#   #       current_subject.destroy_account
#   #
#   #       expect(File.exist?(OVERRIDABLE_FILENAME)).to be true
#   #       file_accounts = YAML.load_file(OVERRIDABLE_FILENAME)
#   #       expect(file_accounts).to be_a Array
#   #       expect(file_accounts.size).to be 2
#   #     end
#   #
#   #     it 'doesnt delete account' do
#   #       expect($stdin).to receive_message_chain(:gets, :chomp) { cancel_input }
#   #
#   #       current_subject.destroy_account
#   #
#   #       expect(File.exist?(OVERRIDABLE_FILENAME)).to be false
#   #     end
#   #   end
#   # end
#   #
#   # describe '#show_cards' do
#   #   let(:cards) { [Card.new('a'), Card.new('b')] }
#   #
#   #   it 'display cards if there are any' do
#   #     card_operations.instance_variable_set(:@account, instance_double('Account', cards: cards))
#   #     current_subject.instance_variable_set(:@card_operations, card_operations)
#   #     cards.each { |card| expect(view).to receive(:puts).with("- #{card.number}, #{card.type}") }
#   #     current_subject.show_cards
#   #   end
#   #
#   #   it 'outputs error if there are no active cards' do
#   #     card_operations.instance_variable_set(:@account, instance_double('Account', cards: []))
#   #     current_subject.instance_variable_set(:@card_operations, card_operations)
#   #     expect(view).to receive(:puts).with(ERROR_PHRASES[:no_active_cards])
#   #     current_subject.show_cards
#   #   end
#   # end
#   #
#   # describe '#create_card' do
#   #   let(:test_account) { instance_double('Account', cards: []) }
#   #
#   #   context 'with correct outout' do
#   #     it do
#   #       CREATE_CARD_PHRASES.each { |phrase| expect(card_operations).to receive(:puts).with(phrase) }
#   #       current_subject.instance_variable_set(:@card_operations, card_operations)
#   #       card_operations.instance_variable_set(:@account, test_account)
#   #       current_subject.instance_variable_set(:@storage, storage)
#   #       allow(storage).to receive(:accounts).and_return([])
#   #       allow(File).to receive(:open)
#   #       allow(test_account).to receive(:add_card)
#   #
#   #       expect($stdin).to receive_message_chain(:gets, :chomp) { 'usual' }
#   #
#   #       current_subject.create_card
#   #     end
#   #   end
#   #
#   #   context 'when correct card choose' do
#   #     after do
#   #       File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
#   #     end
#   #
#   #     before do
#   #       allow(account).to receive(:cards).and_return([])
#   #       current_subject.instance_variable_set(:@account, account)
#   #       storage.instance_variable_set(:@accounts, [account])
#   #       current_subject.instance_variable_set(:@storage, storage)
#   #       card_operations.instance_variable_set(:@account, account)
#   #       card_operations.instance_variable_set(:@storage, storage)
#   #       current_subject.instance_variable_set(:@card_operations, card_operations)
#   #     end
#   #
#   #     CARDS.each do |card_type, card_info|
#   #       it "create card with #{card_type} type" do
#   #         expect($stdin).to receive_message_chain(:gets, :chomp) { card_info[:type] }
#   #
#   #         current_subject.create_card
#   #
#   #         expect(File.exist?(OVERRIDABLE_FILENAME)).to be true
#   #         file_accounts = YAML.load_file(OVERRIDABLE_FILENAME)
#   #         expect(file_accounts.first.cards.first.type).to eq card_info[:type]
#   #         expect(file_accounts.first.cards.first.balance).to eq card_info[:balance]
#   #         expect(file_accounts.first.cards.first.number.length).to be 16
#   #       end
#   #     end
#   #   end
#   #
#   #   context 'when incorrect card choose' do
#   #     it do
#   #       current_subject.instance_variable_set(:@account, account)
#   #       card_operations.instance_variable_set(:@account, account)
#   #       card_operations.instance_variable_set(:@storage, storage)
#   #       current_subject.instance_variable_set(:@card_operations, card_operations)
#   #       allow(File).to receive(:open)
#   #       allow(storage).to receive(:accounts).and_return([])
#   #       allow($stdin).to receive_message_chain(:gets, :chomp).and_return('test', 'usual')
#   #
#   #       expect { current_subject.create_card }.to output(/#{ERROR_PHRASES[:wrong_card_type]}/).to_stdout
#   #     end
#   #   end
#   # end
#   #
#   # describe '#destroy_card' do
#   #   context 'without cards' do
#   #     it 'shows message about not active cards' do
#   #       card_operations.instance_variable_set(:@account, instance_double('Account', cards: []))
#   #       current_subject.instance_variable_set(:@card_operations, card_operations)
#   #       expect { current_subject.destroy_card }.to output(/#{ERROR_PHRASES[:no_active_cards]}/).to_stdout
#   #     end
#   #   end
#   #
#   #   context 'with cards' do
#   #     let(:card_one) { Card.new('test') }
#   #     let(:card_two) { Card.new('test2') }
#   #     let(:fake_cards) { [card_one, card_two] }
#   #
#   #     before do
#   #       card_operations.instance_variable_set(:@account, account)
#   #       current_subject.instance_variable_set(:@card_operations, card_operations)
#   #     end
#   #
#   #     context 'with correct outout' do
#   #       it do
#   #         allow(account).to receive(:cards) { fake_cards }
#   #         current_subject.instance_variable_set(:@account, account)
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return('exit')
#   #         expect { current_subject.destroy_card }.to output(/#{COMMON_PHRASES[:if_you_want_to_delete]}/).to_stdout
#   #         fake_cards.each_with_index do |card, i|
#   #           message = /- #{card.number}, #{card.type}, press #{i + 1}/
#   #           expect { current_subject.destroy_card }.to output(message).to_stdout
#   #         end
#   #       end
#   #     end
#   #
#   #     context 'when exit if first gets is exit' do
#   #       it do
#   #         allow(account).to receive(:cards) { fake_cards }
#   #         current_subject.instance_variable_set(:@account, account)
#   #         expect($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
#   #         current_subject.destroy_card
#   #       end
#   #     end
#   #
#   #     context 'with incorrect input of card number' do
#   #       before do
#   #         allow(account).to receive(:cards) { fake_cards }
#   #         current_subject.instance_variable_set(:@account, account)
#   #       end
#   #
#   #       it do
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(fake_cards.length + 1, 'exit')
#   #         expect { current_subject.destroy_card }.to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
#   #       end
#   #
#   #       it do
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(-1, 'exit')
#   #         expect { current_subject.destroy_card }.to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
#   #       end
#   #     end
#   #
#   #     context 'with correct input of card number' do
#   #       let(:accept_for_deleting) { 'y' }
#   #       let(:reject_for_deleting) { 'asdf' }
#   #       let(:deletable_card_number) { 1 }
#   #
#   #       before do
#   #         card_operations.instance_variable_set(:@storage, storage)
#   #         account.instance_variable_set(:@cards, fake_cards)
#   #         storage.instance_variable_set(:@accounts, [account])
#   #         current_subject.instance_variable_set(:@current_account, account)
#   #       end
#   #
#   #       after do
#   #         File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
#   #       end
#   #
#   #       it 'accept deleting' do
#   #         commands = [deletable_card_number, accept_for_deleting]
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)
#   #
#   #         expect { current_subject.destroy_card }.to change { current_subject.current_account.cards.size }.by(-1)
#   #
#   #         expect(File.exist?(OVERRIDABLE_FILENAME)).to be true
#   #         file_accounts = YAML.load_file(OVERRIDABLE_FILENAME)
#   #         expect(file_accounts.first.cards).not_to include(card_one)
#   #       end
#   #
#   #       it 'decline deleting' do
#   #         commands = [deletable_card_number, reject_for_deleting]
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)
#   #
#   #         expect { current_subject.destroy_card }.not_to change(current_subject.current_account.cards, :size)
#   #       end
#   #     end
#   #   end
#   # end
#   #
#   # describe '#put_money' do
#   #   context 'without cards' do
#   #     it 'shows message about not active cards' do
#   #       current_subject.instance_variable_set(:@current_account, instance_double('Account', cards: []))
#   #       current_subject.instance_variable_set(:@money_operations, money_operations)
#   #       expect { current_subject.put_money }.to output(/#{ERROR_PHRASES[:no_active_cards]}/).to_stdout
#   #     end
#   #   end
#   #
#   #   context 'with cards' do
#   #     let(:card_one) { Card.new('test') }
#   #     let(:card_two) { Card.new('test2') }
#   #     let(:fake_cards) { [card_one, card_two] }
#   #
#   #     before do
#   #       allow(account).to receive(:cards) { fake_cards }
#   #       current_subject.instance_variable_set(:@current_account, account)
#   #       money_operations.instance_variable_set(:@account, account)
#   #       current_subject.instance_variable_set(:@money_operations, money_operations)
#   #     end
#   #
#   #     context 'with correct outout' do
#   #       it do
#   #         allow($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
#   #         expect { current_subject.put_money }.to output(/#{COMMON_PHRASES[:choose_card]}/).to_stdout
#   #         fake_cards.each_with_index do |card, i|
#   #           message = /- #{card.number}, #{card.type}, press #{i + 1}/
#   #           expect { current_subject.put_money }.to output(message).to_stdout
#   #         end
#   #         current_subject.put_money
#   #       end
#   #     end
#   #
#   #     context 'when exit if first gets is exit' do
#   #       it do
#   #         allow(account).to receive(:cards) { fake_cards }
#   #         current_subject.instance_variable_set(:@current_account, account)
#   #         expect($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
#   #         current_subject.put_money
#   #       end
#   #     end
#   #
#   #     context 'with incorrect input of card number' do
#   #       before do
#   #         allow(account).to receive(:cards) { fake_cards }
#   #         current_subject.instance_variable_set(:@current_account, account)
#   #         money_operations.instance_variable_set(:@account, account)
#   #         current_subject.instance_variable_set(:@money_operations, money_operations)
#   #       end
#   #
#   #       it do
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(fake_cards.length + 1, 'exit')
#   #         expect { current_subject.put_money }.to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
#   #       end
#   #
#   #       it do
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(-1, 'exit')
#   #         expect { current_subject.put_money }.to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
#   #       end
#   #     end
#   #
#   #     context 'with correct input of card number' do
#   #       let(:card_one) { CapitalistCard.new(50.0) }
#   #       let(:card_two) { CapitalistCard.new(100.0) }
#   #       let(:fake_cards) { [card_one, card_two] }
#   #       let(:chosen_card_number) { 1 }
#   #       let(:incorrect_money_amount) { -2 }
#   #       let(:default_balance) { 50.0 }
#   #       let(:correct_money_amount_lower_than_tax) { 5 }
#   #       let(:correct_money_amount_greater_than_tax) { 50 }
#   #
#   #       before do
#   #         account.instance_variable_set(:@cards, fake_cards)
#   #         current_subject.instance_variable_set(:@current_account, account)
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)
#   #       end
#   #
#   #       context 'with correct output' do
#   #         let(:commands) { [chosen_card_number, incorrect_money_amount] }
#   #
#   #         it do
#   #           expect { current_subject.put_money }.to output(/#{COMMON_PHRASES[:input_amount]}/).to_stdout
#   #         end
#   #       end
#   #
#   #       context 'with amount lower then 0' do
#   #         let(:commands) { [chosen_card_number, incorrect_money_amount] }
#   #
#   #         it do
#   #           expect { current_subject.put_money }.to output(/#{ERROR_PHRASES[:correct_amount]}/).to_stdout
#   #         end
#   #       end
#   #
#   #       context 'with amount greater then 0' do
#   #         context 'with tax greater than amount' do
#   #           let(:commands) { [chosen_card_number, correct_money_amount_lower_than_tax] }
#   #
#   #           it do
#   #             expect { current_subject.put_money }.to output(/#{ERROR_PHRASES[:tax_higher]}/).to_stdout
#   #           end
#   #         end
#   #
#   #         context 'with tax lower than amount' do
#   #           let(:custom_cards) do
#   #             [
#   #               UsualCard.new(default_balance),
#   #               CapitalistCard.new(default_balance),
#   #               VirtualCard.new(default_balance)
#   #             ]
#   #           end
#   #
#   #           let(:commands) { [chosen_card_number, correct_money_amount_greater_than_tax] }
#   #
#   #           after do
#   #             File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
#   #           end
#   #
#   #           it do
#   #             custom_cards.each do |custom_card|
#   #               allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)
#   #               storage.instance_variable_set(:@accounts, [account])
#   #               current_subject.instance_variable_set(:@storage, storage)
#   #               account.instance_variable_set(:@cards, [custom_card, card_one, card_two])
#   #               current_subject.instance_variable_set(:@current_account, account)
#   #               new_balance = default_balance + correct_money_amount_greater_than_tax - custom_card.put_tax(correct_money_amount_greater_than_tax)
#   #
#   #               expect { current_subject.put_money }.to output(
#   #                 /Money #{correct_money_amount_greater_than_tax} was put on #{custom_card.number}. Balance: #{new_balance}. Tax: #{custom_card.put_tax(correct_money_amount_greater_than_tax)}/
#   #               ).to_stdout
#   #
#   #               expect(File.exist?(OVERRIDABLE_FILENAME)).to be true
#   #               file_accounts = YAML.load_file(OVERRIDABLE_FILENAME)
#   #               expect(file_accounts.first.cards.first.balance).to eq(new_balance)
#   #             end
#   #           end
#   #         end
#   #       end
#   #     end
#   #   end
#   # end
#   #
#   # describe '#withdraw_money' do
#   #   context 'without cards' do
#   #     it 'shows message about not active cards' do
#   #       current_subject.instance_variable_set(:@current_account, instance_double('Account', cards: []))
#   #       current_subject.instance_variable_set(:@money_operations, money_operations)
#   #       expect { current_subject.withdraw_money }.to output(/#{ERROR_PHRASES[:no_active_cards]}/).to_stdout
#   #     end
#   #   end
#   #
#   #   context 'with cards' do
#   #     let(:card_one) { Card.new('test') }
#   #     let(:card_two) { Card.new('test2') }
#   #     let(:fake_cards) { [card_one, card_two] }
#   #
#   #     context 'with correct outout' do
#   #       it do
#   #         allow(account).to receive(:cards) { fake_cards }
#   #         current_subject.instance_variable_set(:@current_account, account)
#   #         allow($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
#   #         current_subject.instance_variable_set(:@money_operations, money_operations)
#   #         expect { current_subject.withdraw_money }.to output(/#{COMMON_PHRASES[:choose_card_withdrawing]}/).to_stdout
#   #         fake_cards.each_with_index do |card, i|
#   #           message = /- #{card.number}, #{card.type}, press #{i + 1}/
#   #           expect { current_subject.withdraw_money }.to output(message).to_stdout
#   #         end
#   #         current_subject.withdraw_money
#   #       end
#   #     end
#   #
#   #     context 'when exit if first gets is exit' do
#   #       it do
#   #         allow(account).to receive(:cards) { fake_cards }
#   #         current_subject.instance_variable_set(:@current_account, account)
#   #         current_subject.instance_variable_set(:@money_operations, money_operations)
#   #         expect($stdin).to receive_message_chain(:gets, :chomp) { 'exit' }
#   #         current_subject.withdraw_money
#   #       end
#   #     end
#   #
#   #     context 'with incorrect input of card number' do
#   #       before do
#   #         allow(account).to receive(:cards) { fake_cards }
#   #         current_subject.instance_variable_set(:@current_account, account)
#   #         current_subject.instance_variable_set(:@money_operations, money_operations)
#   #       end
#   #
#   #       it do
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(fake_cards.length + 1, 'exit')
#   #         expect { current_subject.withdraw_money }.to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
#   #       end
#   #
#   #       it do
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(-1, 'exit')
#   #         expect { current_subject.withdraw_money }.to output(/#{ERROR_PHRASES[:wrong_number]}/).to_stdout
#   #       end
#   #     end
#   #
#   #     context 'with correct input of card number' do
#   #       let(:card_one) { CapitalistCard.new(50.0) }
#   #       let(:card_two) { CapitalistCard.new(100.0) }
#   #       let(:fake_cards) { [card_one, card_two] }
#   #       let(:chosen_card_number) { 1 }
#   #       let(:incorrect_money_amount) { -2 }
#   #       let(:default_balance) { 50.0 }
#   #       let(:correct_money_amount_lower_than_tax) { 5 }
#   #       let(:correct_money_amount_greater_than_tax) { 50 }
#   #
#   #       before do
#   #         account.instance_variable_set(:@cards, fake_cards)
#   #         current_subject.instance_variable_set(:@current_account, account)
#   #         current_subject.instance_variable_set(:@money_operations, money_operations)
#   #         allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*commands)
#   #       end
#   #
#   #       context 'with correct output' do
#   #         let(:commands) { [chosen_card_number, incorrect_money_amount] }
#   #
#   #         it do
#   #           expect { current_subject.withdraw_money }.to output(/#{COMMON_PHRASES[:withdraw_amount]}/).to_stdout
#   #         end
#   #       end
#   #     end
#   #   end
#   # end
#
# end
