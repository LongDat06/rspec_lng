module Identity
  class ApplicationController < ActionController::API
    include Pagy::Backend
    include ::Shared::ExceptionHandler
    include ::Shared::ResponseSerializer
    include ::Shared::AuthProtection
    include Pundit
  end
end
