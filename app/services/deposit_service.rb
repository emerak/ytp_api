# frozen_string_literal: true
class DepositService

  attr_reader :errors, :account

  def initialize(params)
    @user = User.find_by(email: params[:email])
    @amount = params[:amount]
    @errors = ActiveModel::Errors.new(User.new)
  end

  def call
    validate
    return if @errors.any?

    @account = @user.account
    @account.deposit!(@amount)
  rescue StandardError => e
    @errors.clear
    @errors.add(:base, :invalid, message: error_messages(e.message))
  end

  private

  def validate
    @errors.add(:base, :invalid, message: "can't make deposit on this user") if @user.nil? || @user.admin?
    @errors.add(:base, :invalid, message: 'invalid account') if @user&.account.blank?
    @errors.add(:base, :invalid, message: 'invalid amount') if @amount.blank?
  end

  def error_messages(message)
    case message
    when 'Validation failed: Balance must be greater than or equal to 0'
      'Not enough funds in your account'
    else
      message
    end
  end
end
