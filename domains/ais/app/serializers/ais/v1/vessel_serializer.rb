module Ais
  module V1
    class VesselSerializer
      include FastJsonapi::ObjectSerializer

      attribute :id, :imo, :engine_type, :ecdis_email, :target, :created_at, :updated_at, :name, :sim_data_type, :genre_error_code

      attribute :error_message do |object|
        object.error_code_text
      end
    end
  end
end
