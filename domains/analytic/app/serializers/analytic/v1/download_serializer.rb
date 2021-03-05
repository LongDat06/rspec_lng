module Analytic
  module V1
    class DownloadSerializer
      include FastJsonapi::ObjectSerializer

      attributes :id, :source, :status, :created_at, :imo_no, :author_id

      attribute :content_url do |object|
        object.content_url
      end

      attribute :condition do |object|
        {
          timestamp_from_at: object.condition.timestamp_from_at,
          timestamp_to_at: object.condition.timestamp_to_at
        }
      end
    end
  end
end
