module Analytic
  module V1
    class SimChannelSerializer
      include FastJsonapi::ObjectSerializer

      attributes :id, :local_name, :unit, :standard_name, :created_at
      attribute :unit do |object|
        object.unit || "N/A"
      end
    end
  end
end
