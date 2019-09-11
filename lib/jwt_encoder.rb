# frozen_string_literal: true

module JwtEncoder
  def self.encode(user, expiration = 1.hour)
    secret = Rails.application.credentials.secret_key_base
    app_id = Rails.application.credentials.app_id

    exp = Time.current.to_i + expiration.to_i

    payload = {
      data: user,
      iss: app_id,
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
