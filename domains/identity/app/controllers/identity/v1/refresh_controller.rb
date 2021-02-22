module Identity
  module V1
    class RefreshController < BaseController
      skip_before_action :authorize_request, only: :create

      def create
        new_access_token, new_refresh_token = ::Identity::JwtServices::Refresher.new(
          access_token: old_access_token, refresh_token: old_refresh_token
        ).()
        set_access_token(new_access_token)
        set_refresh_token(new_refresh_token)
        json_response({})
      end

      private
      def old_access_token
        cookies[:access_token]
      end

      def old_refresh_token
        cookies[:refresh_token]
      end

      def set_access_token(token)
        cookies[:access_token] = {
          value: token,
          httponly: true
        }
      end

      def set_refresh_token(token)
        cookies[:refresh_token] = {
          value: token,
          httponly: true
        }
      end
    end
  end
end
