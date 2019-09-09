# frozen_string_literal: true

module JwtEncoder
  def self.encode(user, expiration = 1.hour)
    secret = Rails.application.credentials.secret_key_base

    exp = Time.current.to_i + expiration.to_i

    payload = {
      data: user,
      iss: ENV['APP_ID'],
      verify_iss: true,
      algorithm: 'HS256',
      exp: exp
    }

    begin
      JWT.encode(payload, secret, 'HS256')
    rescue StandardError
      nil
    end
  end
end
