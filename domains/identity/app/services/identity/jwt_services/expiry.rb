module Identity
  module JwtServices
    class Expiry
      def self.access_expiry
        5.minutes
      end

      def self.refresh_expiry
        1.day
      end
    end
  end
end
