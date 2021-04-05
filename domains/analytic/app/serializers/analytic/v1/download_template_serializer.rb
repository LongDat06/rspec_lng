module Analytic
  module V1
    class DownloadTemplateSerializer
      include FastJsonapi::ObjectSerializer

      attributes :id, :author_id, :imo_no, :shared, :name, :channels
    end
  end
end
