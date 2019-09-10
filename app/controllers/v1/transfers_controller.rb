# frozen_string_literal: true

module V1
  class TransfersController < ApplicationController
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
