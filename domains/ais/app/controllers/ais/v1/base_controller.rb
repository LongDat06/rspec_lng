module Ais
  module V1
    class BaseController < ApplicationController
      include Pagy::Backend
      include ::Shared::ResponseSerializer
      include ::Shared::ExceptionHandler
      include ::Shared::AuthProtection
    end
  end
end
