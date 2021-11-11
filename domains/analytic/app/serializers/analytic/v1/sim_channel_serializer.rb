module Analytic
  module V1
    class SimChannelSerializer
      include FastJsonapi::ObjectSerializer

      attributes :id, :local_name, :unit, :standard_name, :genre, :created_at
      attribute :unit do |object|
        object.unit || Analytic::SimChannel::NOT_AVAILABLE_TYPE
      end

      attribute :genre do |object|
        object.genre || Analytic::Genre::NOT_AVAILABLE_TYPE
      end
    end
  end
end
