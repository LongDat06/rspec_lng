module Analytic
  module V1
    class BaseController < ApplicationController
      include Pagy::Backend
      include Ais::ResponseSerializer
      include Ais::ExceptionHandler
    end
  end
end
