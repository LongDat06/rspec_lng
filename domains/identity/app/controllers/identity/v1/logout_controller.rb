module Identity
  module V1
    class LogoutController < BaseController
      def create
        Token.find_by(crypted_token: cookies[:refresh_token])&.destroy!
        cookies.delete :access_token
        cookies.delete :refresh_token
        json_response({})
      end
    end
  end
end
