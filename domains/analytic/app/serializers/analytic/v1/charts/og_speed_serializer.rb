module Analytic
  module V1
    module Charts
      class OgSpeedSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_nav_gnss_sog do |object|
          object.spec['jsmea_nav_gnss_sog']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end

      end
    end
  end
end
