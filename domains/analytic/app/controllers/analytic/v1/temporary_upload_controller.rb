module Analytic
  module V1
    class TemporaryUploadController < BaseController

      def upload
        set_rack_response Analytic::Uploader::TemporaryUploader.upload_response(:cache, request.env)
      end

      private
        def set_rack_response((status, headers, body))
          self.status = status
          self.headers.merge!(headers)
          self.response_body = body
        end
    end
  end
end
