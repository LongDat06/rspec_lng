module Analytic
  module V1
    module Charts
      module VoyageSummary
        class XdfLngConsumptionSerializer
          include FastJsonapi::ObjectSerializer

          set_type :xdf

          attribute :timestamp, :selected_voyage_no, :vessel_name, :view_day, :all_voyages, :voyage_props

          attribute :avg_lng_consumption do |object|
            object.average_values
          end

        end
      end
    end
  end
end
