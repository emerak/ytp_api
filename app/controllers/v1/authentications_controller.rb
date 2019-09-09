# frozen_string_literal: true
require 'jwt_encoder'

module V1
  class AuthenticationsController < ApplicationController
    def create
      user = User.find_by(email: user_params[:email])

      if user&.authenticate(user_params[:password])
        render json: { token: JwtEncoder.encode(user.id) }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end

    private

    def user_params
      params.permit(:email, :password)
    end
  end
end
