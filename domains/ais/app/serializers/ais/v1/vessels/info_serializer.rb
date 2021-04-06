module Ais
  module V1
    module Vessels
      class InfoSerializer
        include FastJsonapi::ObjectSerializer

        attribute :id, :imo, :engine_type, :ecdis_email, :target, :created_at, :updated_at, :name
      end
    end
  end
end
