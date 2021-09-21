# RSpec.describe AccountConnect do
#   let(:current_subject) { described_class.new }
#   let(:storage) { Storage.new }
#   let(:view) { Output }
#
#
#   describe '#create' do
#     let(:success_name_input) { 'Denis' }
#     let(:success_age_input) { '72' }
#     let(:success_login_input) { 'Denis' }
#     let(:success_password_input) { 'Denis1993' }
#     let(:success_inputs) { [success_name_input, success_login_input, success_password_input, success_age_input] }
#     let(:account_registration) { AccountRegistration.new(storage, success_name_input, success_login_input, success_password_input, success_age_input) }
#
#     context 'with success result' do
#       before do
#         # allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*success_inputs)
#         stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#
#         allow(storage).to receive(:accounts).and_return([])
#       end
#
#       after do
#         File.delete(Helper::OVERRIDABLE_FILENAME) if File.exist?(Helper::OVERRIDABLE_FILENAME)
#       end
#
#       it 'write to file Account instance' do
#         current_subject.create(success_name_input, success_login_input, success_age_input, success_password_input)
#         expect(File.exist?(Helper::OVERRIDABLE_FILENAME)).to be true
#         accounts = YAML.load_file(Helper::OVERRIDABLE_FILENAME)
#         expect(accounts).to be_a Array
#         expect(accounts.size).to be 1
#         accounts.map { |account| expect(account).to be_a Account }
#       end
#     end
#   end
#
#   describe '#load' do
#     context 'without active accounts' do
#       before do
#         stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#       end
#       it do
#         expect(storage.accounts).to be_empty
#         current_subject.load('123', '123')
#       end
#     end
#
#     context 'with active accounts' do
#       let(:name) { 'Johnny' }
#       let(:login) { 'Johnny' }
#       let(:password) { 'johnny1' }
#       let(:age) { 34 }
#
#
#
#       # context 'with correct outout' do
#       #   let(:all_inputs) { [login, password] }
#       #
#       #   it do
#       #     [Helper::ASK_PHRASES[:login], Helper::ASK_PHRASES[:password]].each do |phrase|
#       #       expect(view).to receive(:puts).with(phrase)
#       #     end
#       #     current_subject.load(*all_inputs)
#       #   end
#       # end
#       context 'when account doesn\t exists' do
#         let(:all_inputs) { [login, password] }
#
#         it do
#           expect(current_subject.load(*all_inputs)).to be_nil
#         end
#       end
#
#       # context 'when account doesn\t exists' do
#       #   let(:all_inputs) { ['test', 'test'] }
#       #
#       #   it do
#       #     expect(current_subject).to receive(:create_operations)
#       #     current_subject.load(*all_inputs)
#       #   end
#       # end
#
#     #   context 'when account exists' do
#     #     let(:all_inputs) { [login, password] }
#     #
#     #     it do
#     #       expect { current_subject.load(*all_inputs) }.not_to output(/#{Helper::ERROR_PHRASES[:user_not_exists]}/).to_stdout
#     #     end
#     #   end
#     #
#       context 'when accounts exist' do
#         before do
#           # allow($stdin).to receive_message_chain(:gets, :chomp).and_return(*all_inputs)
#           stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#           allow(storage).to receive(:accounts) { [Account.new(name, login, password, age)] }
#           allow(Storage).to receive(:new).and_return(storage)
#
#           # storage.instance_variable_set(:@accounts, [Account.new(name, login, password, age)])
#         end
#         let(:all_inputs) { [login, password] }
#
#         it do
#           puts storage.accounts.inspect
#           allow(storage).to receive(:find_account?).and_return(storage.accounts.first)
#           expect(current_subject.load(*all_inputs)).to be_truthy
#         end
#       end
#     end
#   end
#
#   describe '#no_accounts?' do
#     context 'without active accounts' do
#       before do
#         stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#       end
#       it { expect(current_subject.no_accounts?).to be_truthy }
#     end
#
#     context 'with active accounts' do
#       let(:name) { 'Johnny' }
#       let(:login) { 'Johnny' }
#       let(:password) { 'johnny1' }
#       let(:age) { 1 }
#
#       before do
#         allow(Storage).to receive(:new).and_return(storage)
#         stub_const('Storage::FILE', Helper::OVERRIDABLE_FILENAME)
#         allow(storage).to receive(:accounts) { [Account.new(name, login, password, age)] }
#         storage.instance_variable_set(:@accounts, [Account.new(name, login, password, age)])
#
#       end
#
#       context 'when accounts exist' do
#         it do
#           expect(current_subject.no_accounts?).to be_falsey
#         end
#       end
#     end
#   end
#
#
#   describe '#chose_command' do
#     let(:cancel_input) { 'sdfsdfs' }
#     let(:success_input) { 'SC' }
#     let(:output) { current_subject.chose_command(success_input) }
#
#
#     it 'returns symbol if user inputs is in hash' do
#
#       expect(output).to eq(:show_cards)
#     end
#
#     it 'returns nil if user inputs is not in hash' do
#       current_subject.chose_command(cancel_input)
#     end
#   end
#
# end