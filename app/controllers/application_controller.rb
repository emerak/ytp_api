class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!

    return render json: { error: 'token not present' }, status: :unauthorized unless token

    decoded_token = JwtDecoder.decode(token)

    render json: { error: 'invalid token' }, status: :unauthorized unless decoded_token
  end

  def token
    @token ||= request.headers['Authorization']&.split(' ')&.last
  end
end
