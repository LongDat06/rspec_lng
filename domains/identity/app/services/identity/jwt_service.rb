module Identity
  class JwtServiceInvalid < StandardError; end
  class JwtServicePayloadEmpty < StandardError; end
  class JwtService
    HMAC_ACCESS_SECRET  = ENV['JWT_ACCESS_PRIVATE_KEY']
    HMAC_REFRESH_SECRET = ENV['JWT_REFRESH_PRIVATE_KEY']

    WARN_EXCEPTIONS = [
      JWT::DecodeError,
      JWT::ExpiredSignature,
      JWT::ImmatureSignature,
      JWT::VerificationError,
      JwtServiceInvalid
    ]

    def self.encode(payload, verify_key = HMAC_ACCESS_SECRET, exp = 5.minutes.from_now)
      raise(JwtServicePayloadEmpty) if payload.blank?
      payload[:exp] = exp.to_i
      JWT.encode(payload, verify_key)
    end

    def self.decode(token, verify_key = HMAC_ACCESS_SECRET)
      body = JWT.decode(token, verify_key)[0]
      HashWithIndifferentAccess.new body
    end
  end
end
