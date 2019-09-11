module JwtDecoder
  def self.decode(token)
    secret = Rails.application.credentials.secret_key_base
    app_id = Rails.application.credentials.app_id

    payload = {
      iss: app_id,
      verify_iss: true,
      algorithm: 'HS256'
    }

    begin
      JWT.decode(token, secret, true, payload)
    rescue StandardError => e
      e
    end
  end
end
