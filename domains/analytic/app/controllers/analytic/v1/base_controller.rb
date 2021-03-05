module Analytic
  module V1
    class BaseController < ApplicationController
      include Pagy::Backend
      include Analytic::PagyMongoid
      include ::Shared::ResponseSerializer
      include ::Shared::ExceptionHandler
      include ::Shared::AuthProtection
    end
  end
end
