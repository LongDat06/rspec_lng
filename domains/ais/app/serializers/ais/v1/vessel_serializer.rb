module Ais
  module V1
    class VesselSerializer
      include FastJsonapi::ObjectSerializer

      attribute :id, :imo, :engine_type, :ecdis_email, :target, :created_at, :updated_at, :name

      attribute :error_message do |object|
        object.error_code_text
      end
    end
  end
end
