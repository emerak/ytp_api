# frozen_string_literal: true
class TransferService

  attr_reader :errors

  def initialize(user, clabe, amount)
    @account = user.account
    @user = user
    @clabe = clabe
    @amount = amount
    @errors = @account.errors
  end

  def call
    if @user.external_account.clabe == @clabe
      @account.transfer!(@amount)
    else
      return @errors.add(:clabe, :invalid, message: 'clabe does not match')
    end
  rescue StandardError => e
    @errors.clear
    @errors.add(:base, :invalid, message: e.message)

    @errors = @account.errors
  end
end
