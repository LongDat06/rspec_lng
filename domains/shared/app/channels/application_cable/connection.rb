# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # identified_by :current_user

    # def connect
    #   self.current_user = find_verified_user
    # end

    # private
    #   def find_verified_user
    #     if current_user = user_session_by_jwt
    #       current_user
    #     else
    #       reject_unauthorized_connection
    #     end
    #   end
    #   def user_session_by_jwt
    #     return unless jwt_user_id.present?
    #     ::Shared::User.find_by(id: jwt_user_id)
    #   end

    #   def jwt_user_id
    #    jwt = ::Identity::JwtServices::Decoder.new(jwt_token).()
    #    jwt[:user_id] if jwt.present?
    #   end

    #   def jwt_token
    #     @jwt_token ||= begin
    #       request_cookies = Rack::Utils.parse_cookies(env)
    #       request_cookies['access_token']
    #     end
    #   end
  end
end

