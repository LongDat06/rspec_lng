module Identity
  module SessionServices
    class SessionRepositoryInvalid < StandardError; end
    class SessionRepository
      def initialize(email, password)
        @email = email
        @password = password
      end

      def call
        return raise(
          SessionRepositoryInvalid, I18n.t('identity.session.invalid_credentials')
        ) if construct_session.nil?
        Identity::JwtServices::Issuer.new(construct_session).()
      end

      private
      def construct_session
        @construct_session ||= begin
          user = Identity::User.find_by(email: @email)
          user if user && user.authenticate(@password)
        end
      end
    end
  end
end
