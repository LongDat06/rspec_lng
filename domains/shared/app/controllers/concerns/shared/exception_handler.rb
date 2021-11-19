module Shared
  module ExceptionHandler
    extend ActiveSupport::Concern

    # Define custom error subclasses - rescue catches `StandardErrors`
    class AuthenticationError < StandardError; end
    class AccessDenied < StandardError; end

    included do
      # Define custom handlers
      rescue_from StandardError, with: :render_unexpected_error
      rescue_from ActionController::BadRequest, with: :render_400
      rescue_from AuthenticationError, with: :unauthorized_request
      rescue_from AccessDenied, with: :unauthorized_request
      rescue_from ActiveRecord::RecordInvalid, with: :render_422
      rescue_from Pundit::NotAuthorizedError, with: :permission_denied
    end

    private
    def render_unexpected_error(e)
      Airbrake.notify(e)
      json_response({ message: e.message }, :internal_server_error)
    end

    # JSON response with message; Status code 422 - unprocessable entity
    def render_422(e)
      json_response({ message: e.message }, :unprocessable_entity)
    end

    def render_400(e)
      json_response({ message: e.message }, :bad_request)
    end

    # JSON response with message; Status code 401 - Unauthorized
    def unauthorized_request(e)
      json_response({ message: e.message }, :unauthorized)
    end

    def record_errors(e)
      json_response({ message: e.record.errors.full_messages }, :unprocessable_entity)
    end

    def permission_denied(e)
      json_response({ message: e.message }, :forbidden)
    end
  end
end
