module RegistrationOutput
  def registration_name
    puts I18n.t('registration.name')
  end

  def registration_login
    puts I18n.t('registration.login')
  end

  def registration_age
    puts I18n.t('registration.age')
  end

  def registration_password
    puts I18n.t('registration.password')
  end
end
