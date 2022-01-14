module Analytic
  module V1
    module Charts
      module VoyageSummary
        class StageMgoConsumptionSerializer
          include FastJsonapi::ObjectSerializer

          set_type :stage

          attribute :timestamp,
                    :vessel_name,
                    :selected_voyage_no,
                    :view_day, :all_voyages, :voyage_props

          attribute :avg_mgo_consumption do |object|
            object.average_values
          end

        end
      end
    end
  end
end
