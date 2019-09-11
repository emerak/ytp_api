# frozen_string_literal: true

module V1
  class DepositsController < ApplicationController
    before_action :can_perform?
    before_action :check_params

    formats ['json']
    description "Admin action: Make a Deposit to an user's account given the email address and the amount"
    api :POST, '/v1/deposits'
    param :email, String, desc: 'user email', required: true
    param :amount, String, desc: 'deposit amount', required: true

    def create
      service = DepositService.new(deposit_params)

      service.call

      if service.errors.empty?
        render json: { balance: service.account.balance.format }, status: 200
      else
        render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def deposit_params
      params.permit(:email, :amount)
    end

    def check_params
      return render json: { errors: 'missing email' }, status: :unprocessable_entity unless deposit_params[:email].present?
      return render json: { errors: 'missing amount' }, status: :unprocessable_entity unless deposit_params[:amount].present?
    end
  end
end
