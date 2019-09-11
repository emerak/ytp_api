# frozen_string_literal: true

module V1
  class TransfersController < ApplicationController
    before_action :can_perform?

    formats ['json']
    description "Holder action: Makes a withdrawal to an user's account given the clabe and the amount"
    api :POST, '/v1/transfers'
    header 'Authorization', 'Authorization Header', required: true
    param :destination, String, desc: 'user clabe', required: true
    param :amount, String, desc: 'transfer amount', required: true

    def create
      service = TransferService.new(@token, transfer_params)

      service.call

      if service.errors.empty?
        render json: {
          message: 'success',
          balance: service.external_account.balance.format
        }, status: :ok
      else
        render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def transfer_params
      params.permit(:destination, :amount)
    end

    def can_perform?
      return render json: { error: 'not allowed' }, status: :forbidden \
        unless User.find_by(token: @token)&.holder?
    end
  end
end
