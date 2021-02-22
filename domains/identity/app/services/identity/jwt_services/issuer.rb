module Identity
  module JwtServices
    class Issuer
      def initialize(user)
        @user = user
      end

      def call
        Token.create!(crypted_token: refresh_token)
        [access_token, refresh_token]
      end

      private
      def access_token
        Identity::JwtServices::Encoder.new(@user,
          JwtServices::Secret.access_token,
          JwtServices::Expiry.access_expiry
        ).()
      end

      def refresh_token
        @refresh_token ||= begin
          Identity::JwtServices::Encoder.new(@user,
            JwtServices::Secret.refresh_token,
            JwtServices::Expiry.refresh_expiry
          ).()
        end
      end
    end
  end
end
