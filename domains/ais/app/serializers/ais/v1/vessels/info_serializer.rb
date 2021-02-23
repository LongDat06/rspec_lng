module Ais
  module V1
    module Vessels
      class InfoSerializer
        include FastJsonapi::ObjectSerializer

        attribute :id, :imo, :engine_type, :target, :created_at, :updated_at
      end
    end
  end
end
