module Banking
  module Validation
    class Account
      attr_reader :errors

      def initialize(storage)
        @errors = []
        @storage = storage
      end

      def validate_name(name)
        return if name != '' && name[0].upcase == name[0]

        @errors.push(I18n.t('errors.name'))
      end

      def validate_login(login)
        @errors.push(I18n.t('errors.login.present')) if login.empty?
        @errors.push(I18n.t('errors.login.be_longer')) if login.length < 4
        @errors.push(I18n.t('errors.login.be_shorter')) if login.length > 20
        @errors.push(I18n.t('errors.login.exists')) if @storage.accounts.map(&:login).include? login
      end

      def validate_age(age)
        @errors.push(I18n.t('errors.age')) unless age.to_i.between?(23, 90)
      end

      def validate_password(password)
        @errors.push(I18n.t('errors.password.present')) if password.empty?
        @errors.push(I18n.t('errors.password.be_longer')) if password.length < 6
        @errors.push(I18n.t('errors.password.be_shorter')) if password.length > 30
      end

      def exist_no_errors?
        @errors.empty?
      end

      def clear_errors
        @errors = []
      end
    end
  end
end
