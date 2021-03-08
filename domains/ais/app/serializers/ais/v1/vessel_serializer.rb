module Ais
  module V1
    class VesselSerializer
      include FastJsonapi::ObjectSerializer

      attribute :id, :imo, :engine_type, :ecdis_email, :target, :created_at, :updated_at
    end
  end
end
