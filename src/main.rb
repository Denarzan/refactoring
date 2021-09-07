require_relative 'console'
require 'i18n'
I18n.load_path << Dir["#{File.expand_path('config/locales')}/*.yml"]
I18n.config.available_locales = :en
Console.new.console
