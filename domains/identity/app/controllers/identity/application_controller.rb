module Identity
  class ApplicationController < ActionController::API
    include Pagy::Backend
    include ::Shared::ExceptionHandler
    include ::Shared::ResponseSerializer
    include ::Shared::AuthProtection
    include Pundit
    
    rescue_from Pundit::NotAuthorizedError, with: :permission_denied
      
    def permission_denied
      head 403
    end
  end
end
