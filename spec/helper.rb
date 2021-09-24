module Helper
  OVERRIDABLE_FILENAME = 'spec/fixtures/accounts.yml'.freeze

  COMMON_PHRASES = {
    create_first_account: I18n.t('test.common_phrases.create_first_account'),
    destroy_account: I18n.t('test.common_phrases.destroy_account'),
    if_you_want_to_delete: I18n.t('test.common_phrases.if_you_want_to_delete'),
    choose_card: I18n.t('test.common_phrases.choose_card'),
    choose_card_withdrawing: I18n.t('test.common_phrases.choose_card_withdrawing'),
    input_amount: I18n.t('test.common_phrases.input_amount'),
    withdraw_amount: I18n.t('test.common_phrases.withdraw_amount')
  }.freeze

  HELLO_PHRASES = [
    I18n.t('test.hello_phrases.hello'),
    I18n.t('test.hello_phrases.create'),
    I18n.t('test.hello_phrases.load'),
    I18n.t('test.hello_phrases.exit')
  ].freeze

  ASK_PHRASES = {
    name:  I18n.t('test.ask_phrases.name'),
    login: I18n.t('test.ask_phrases.login'),
    password: I18n.t('test.ask_phrases.password'),
    age: I18n.t('test.ask_phrases.age')
  }.freeze

  CREATE_CARD_PHRASES = [
    I18n.t('test.create_card_phrases.create'),
    I18n.t('test.create_card_phrases.usual'),
    I18n.t('test.create_card_phrases.capitalist'),
    I18n.t('test.create_card_phrases.virtual'),
    I18n.t('test.create_card_phrases.exit')
  ].freeze

  ACCOUNT_VALIDATION_PHRASES = {
    name: {
      first_letter: I18n.t('test.account_validation_phrases.name.first_letter')
    },
    login: {
      present: I18n.t('test.account_validation_phrases.login.present'),
      longer: I18n.t('test.account_validation_phrases.login.longer'),
      shorter: I18n.t('test.account_validation_phrases.login.shorter'),
      exists: I18n.t('test.account_validation_phrases.login.exists')
    },
    password: {
      present: I18n.t('test.account_validation_phrases.password.present'),
      longer: I18n.t('test.account_validation_phrases.password.longer'),
      shorter: I18n.t('test.account_validation_phrases.password.shorter')
    },
    age: {
      length: I18n.t('test.account_validation_phrases.age.length')
    }
  }.freeze

  ERROR_PHRASES = {
    user_not_exists: I18n.t('test.error_phrases.user_not_exists'),
    wrong_command: I18n.t('test.error_phrases.wrong_command'),
    no_active_cards: I18n.t('test.error_phrases.no_active_cards'),
    wrong_card_type: I18n.t('test.error_phrases.wrong_card_type'),
    wrong_number: I18n.t('test.error_phrases.wrong_number'),
    correct_amount: I18n.t('test.error_phrases.correct_amount'),
    tax_higher: I18n.t('test.error_phrases.tax_higher')
  }.freeze

  MAIN_OPERATIONS_TEXTS = [
    I18n.t('test.main_operations_texts.start'),
    I18n.t('test.main_operations_texts.show_cards'),
    I18n.t('test.main_operations_texts.create_card'),
    I18n.t('test.main_operations_texts.destroy_card'),
    I18n.t('test.main_operations_texts.put_money'),
    I18n.t('test.main_operations_texts.withdraw_money'),
    I18n.t('test.main_operations_texts.send_money'),
    I18n.t('test.main_operations_texts.destroy_account'),
    I18n.t('test.main_operations_texts.exit')
  ].freeze

  CARDS = {
    usual: {
      type: I18n.t('card.usual'),
      balance: 50.00
    },
    capitalist: {
      type: I18n.t('card.capitalist'),
      balance: 100.00
    },
    virtual: {
      type: I18n.t('card.virtual'),
      balance: 150.00
    }
  }.freeze
end