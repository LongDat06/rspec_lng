module Ais
  module V1
    module Ecdis
      class RoutesSerializer
        include FastJsonapi::ObjectSerializer

        attributes :imo, :format_file, :file_name, :etd, :eta, :max_power, :speed, :etd_wpno,
                   :eta_wpno, :optimized, :budget, :received_at
      end
    end
  end
end
