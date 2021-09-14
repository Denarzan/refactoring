class AccountRegistration
  include Input

  def initialize(storage)
    @validator = AccountValidation.new(storage)
  end

  def create_account
    loop do
      data = [name_input, login_input, password_input, age_input]
      return data if @validator.exist_no_errors?

      @validator.show_errors
    end
  end

  private

  def name_input
    View.registration_name
    name = fetch_input
    @validator.validate_name(name)
    name
  end

  def login_input
    View.registration_login
    login = fetch_input
    @validator.validate_login(login)
    login
  end

  def age_input
    View.registration_age
    age = fetch_input
    @validator.validate_age(age)
    age
  end

  def password_input
    View.registration_password
    password = fetch_input
    @validator.validate_password(password)
    password
  end
end
