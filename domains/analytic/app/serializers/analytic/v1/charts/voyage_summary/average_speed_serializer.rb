module Analytic
  module V1
    module Charts
      module VoyageSummary
        class AverageSpeedSerializer
          include FastJsonapi::ObjectSerializer

          attribute :timestamp, :selected_voyage_no, :vessel_name, :view_day, :all_voyages, :voyage_props

          attribute :average_speed do |object|
            object.average_values
          end

        end
      end
    end
  end
end
