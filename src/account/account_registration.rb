module Banking
  module Account
    class AccountRegistration

      def initialize(storage, name, login, age, password)
        @validator = Validation::Account.new(storage)
        @name = name
        @login = login
        @age = age
        @password = password
      end

      def create_account
        data = [name_validate, login_validate, password_validate, age_validate]

        return data if @validator.exist_no_errors?

        errors = @validator.errors
        @validator.clear_errors
        [nil, errors]
      end

      private

      def name_validate
        @validator.validate_name(@name)
        @name
      end

      def login_validate
        @validator.validate_login(@login)
        @login
      end

      def age_validate
        @validator.validate_age(@age)
        @age
      end

      def password_validate
        @validator.validate_password(@password)
        @password
      end
    end
  end
end
