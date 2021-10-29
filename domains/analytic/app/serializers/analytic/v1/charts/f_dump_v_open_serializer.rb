module Analytic
  module V1
    module Charts
      class FDumpVOpenSerializer
        include FastJsonapi::ObjectSerializer

        set_id :_id

        attribute :jsmea_mac_boilerdumpstmcontvalve_opening do |object|
          object.spec['jsmea_mac_boilerdumpstmcontvalve_opening']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
