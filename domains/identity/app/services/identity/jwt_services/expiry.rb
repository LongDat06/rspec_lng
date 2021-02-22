module Identity
  module JwtServices
    class Expiry
      def self.access_expiry
        15.minutes
      end

      def self.refresh_expiry
        1.days
      end
    end
  end
end
