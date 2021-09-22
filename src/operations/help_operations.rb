module HelpOperations
  private

  def card_exist?(account)
    return true if account.cards.any?

    false
  end
end
