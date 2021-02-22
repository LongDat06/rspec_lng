module Identity
  module JwtServices
    class InvalidToken < StandardError; end
    class Decoder
      WARN_EXCEPTIONS = [
        JWT::DecodeError,
        JWT::ExpiredSignature,
        JWT::ImmatureSignature,
        JWT::VerificationError,
        JwtServices::InvalidToken
      ]

      def initialize(
        token, 
        verify_key = Identity::JwtServices::Secret.access_token, 
        verify: true
      )
        @token = token
        @verify_key = verify_key
        @verify = verify
      end

      def call
        body = JWT.decode(@token, @verify_key, @verify, verify_iat: true)[0]
        raise JwtServices::InvalidToken unless body.present?
        body.symbolize_keys
      rescue *WARN_EXCEPTIONS => e
        Rails.logger.warn("[LNG::JWT] Failed to validate JWT: [#{e.class}] #{e}")
        nil
      end
    end
  end
end
