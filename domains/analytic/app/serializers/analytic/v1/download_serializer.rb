module Analytic
  module V1
    class DownloadSerializer
      include FastJsonapi::ObjectSerializer

      attributes :id, :source, :status, :created_at, :imo_no, :author_id, :vessel_name

      attribute :content_url do |object|
        object.content_downloadable
      end

      attribute :condition do |object|
        {
          timestamp_from_at: object.condition.timestamp_from_at&.utc,
          timestamp_to_at: object.condition.timestamp_to_at&.utc
        }
      end
    end
  end
end
