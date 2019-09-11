# frozen_string_literal: true

module V1
  class RegistrationsController < ApplicationController
    before_action :can_perform?

    formats ['json']
    description 'Admin action: Creates a holder given an email and password'
    api :POST, '/v1/registrations'
    param :email, String, desc: 'user email', required: true
    param :password, String, desc: 'user password', required: true

    def create
      user = User.new(user_params.merge(role: 'holder'))

      if user.save
        render json: { user: user }, status: :created
      else
        render json: { error: user.errors.full_messages },
          status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.permit(:email, :password)
    end
  end
end
