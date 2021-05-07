module Identity
  module JwtServices
    class Expiry
      def self.access_expiry
        1.weeks
      end

      def self.refresh_expiry
        1.months
      end
    end
  end
end
