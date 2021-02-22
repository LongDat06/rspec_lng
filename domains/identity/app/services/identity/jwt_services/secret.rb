module Identity
  module JwtServices
    class Secret
      def self.access_token
        ENV['JWT_ACCESS_PRIVATE_KEY']
      end

      def self.refresh_token
        ENV['JWT_REFRESH_PRIVATE_KEY']
      end
    end
  end
end
