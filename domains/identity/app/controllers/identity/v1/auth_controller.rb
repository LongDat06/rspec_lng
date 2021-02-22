module Identity
  module V1
    class AuthController < BaseController
      skip_before_action :authorize_request, only: :create
      # skip_after_action :verify_policy_scoped, only: :create
      # skip_after_action :verify_authorized, only: :create
      
      def create
        access_token, refresh_token = ::Identity::SessionServices::SessionRepository.new(
          auth_params[:email], auth_params[:password]
        ).()
        set_access_token(access_token)
        set_refresh_token(refresh_token)
        json_response({})
      end

      private
      def auth_params
        params.permit(:email, :password)
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
