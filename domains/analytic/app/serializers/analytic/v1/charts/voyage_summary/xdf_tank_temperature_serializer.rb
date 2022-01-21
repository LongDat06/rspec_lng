module Analytic
  module V1
    module Charts
      module VoyageSummary
        class XdfTankTemperatureSerializer
          include FastJsonapi::ObjectSerializer

          set_type :xdf

          attribute :timestamp, :selected_voyage_no, :vessel_name, :view_day, :all_voyages, :voyage_props

          attribute :avg_xdf_tank do |object|
            object.average_values
          end

        end
      end
    end
  end
end
