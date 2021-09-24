module Banking
  module SignInOutput
    def sign_in_error
      puts I18n.t('sign_in.error')
    end

    def sign_in_login
      puts I18n.t('sign_in.login')
    end

    def sign_in_password
      puts I18n.t('sign_in.password')
    end
  end
end
