module Analytic
  module V1
    class BaseController < ApplicationController
      PER_PAGE = 50
      include Pagy::Backend
      include Analytic::PagyMongoid
      include ::Shared::ResponseSerializer
      include ::Shared::ExceptionHandler
      include ::Shared::AuthProtection
      include Pundit

      def uploader
        status, headers, metadata = Analytic::Uploader::TemporaryUploader.upload_response(:cache, request.env)
        return JSON.parse(metadata.first) if status == 200
        raise "Cannot upload this file to S3"
      end

      def not_found_record
        raise I18n.t("analytic.no_record")
      end
    end
  end
end
