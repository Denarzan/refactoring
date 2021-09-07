require_relative '../help_methods/input'
require_relative '../validation/validation'
require 'i18n'
class AccountRegistration
  include Input

  def initialize
    @validator = AccountValidation.new
    create_account
  end

  def create_account
    loop do
      data = [name_input, age_input, login_input, password_input]
      return data if @validator.exist_no_errors?

      @validator.show_errors
    end
  end

  private

  def name_input
    name = get_input(I18n.t('registration.name'))
    @validator.validate_name(name)
  end

  def login_input
    login = get_input(I18n.t('registration.login'))
    @validator.validate_login(login)
  end

  def age_input
    age = get_input(I18n.t('registration.age'))
    @validator.validate_age(age)
  end

  def password_input
    password = get_input(I18n.t('registration.password'))
    @validator.validate_password(password)
  end

end
