# frozen_string_literal: true

module V1
  class TransfersController < ApplicationController

    formats ['json']
    description "Make a Deposit to an user's account"
    api :POST, '/v1/transfers'
    param :destination, String, desc: 'user clabe', required: true
    param :amount, String, desc: 'transfer amount', required: true

    def create
      user = User.find_by(token: @token)

      service = TransferService.new(user, transfer_params[:destination], transfer_params[:amount])

      service.call

      if service.errors.empty?
        render json: {
          message: 'success',
          balance: user.external_account.balance.format
        }, status: :ok
      else
        render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def transfer_params
      params.permit(:destination, :amount)
    end
  end
end
