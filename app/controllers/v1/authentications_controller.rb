# frozen_string_literal: true

module V1
  class AuthenticationsController < ApplicationController
    skip_before_action :authenticate_user!

    formats ['json']
    description 'Authenticates an user by email and password'
    api :POST, '/v1/login'
    param :user, Hash, desc: 'User info', required: true do
      param :email, String, desc: 'user email', required: true
      param :password, String, desc: 'user password', required: true
    end

    def create
      user = User.find_by(email: user_params[:email])

      if user&.authenticate(user_params[:password])
        token = JwtEncoder.encode(user.id)
        if user.update_attribute(:token, token)
          render json: { token: token }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
