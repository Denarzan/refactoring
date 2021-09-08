require 'i18n'
require 'yaml'

I18n.load_path << Dir["#{File.expand_path('config/locales', __dir__)}/*.yml"]
I18n.default_locale = :en

require_relative 'src/account/account'
require_relative 'src/account/account_registration'
require_relative 'src/account/account_login'
require_relative 'src/cards/card'
require_relative 'src/cards/virtual_card'
require_relative 'src/cards/capitalist_card'
require_relative 'src/cards/usual_card'
require_relative 'src/console/console'
require_relative 'src/help_methods/input'
require_relative 'src/help_methods/output'
require_relative 'src/operations/card_operations'
require_relative 'src/operations/help_operations'
require_relative 'src/operations/money_operations'
require_relative 'src/storage/storage'
require_relative 'src/validation/validation'
