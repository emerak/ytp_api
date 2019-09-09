module JwtDecoder
  def self.decode(token)
    secret = Rails.application.credentials.secret_key_base

    payload = { aud: ENV['CLIENT_ID'],
                verify_aud: true,
                iss: ENV['APP_ID'],
                verify_iss: true,
                algorithm: 'HS256' }

    begin
      [false, JWT.decode(token, secret, true, payload)]
    rescue  => e
      [true, e]
    end
  end
end
