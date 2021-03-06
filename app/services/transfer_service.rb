# frozen_string_literal: true
class TransferService

  attr_reader :errors, :external_account

  def initialize(token, params)
    @user = User.find_by(token: token)
    @account = @user&.account
    @clabe = params[:destination]
    @amount = params[:amount]
    @external_account = @user&.external_account
    @errors = ActiveModel::Errors.new(User.new)
  end

  def call
    validate
    return if @errors.any?

    @account.transfer!(@amount)
  rescue StandardError => e
    @errors.clear
    @errors.add(:base, :invalid, message: error_messages(e.message))
  end

  private

  def validate
    @errors.add(:base, :invalid, message: "can't make deposit on this user") if @user.nil? || @user.admin?
    @errors.add(:base, :invalid, message: 'invalid account') if @account.nil?
    @errors.add(:base, :invalid, message: 'invalid amount') if @amount.blank?
    @errors.add(:base, :invalid, message: 'incorrect clabe') if @external_account&.clabe != @clabe || @clabe.blank?
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
