module Analytic
  module V1
    module Charts
      module VoyageSummary
        class StageTankTemperatureSerializer
          include FastJsonapi::ObjectSerializer

          set_type :stage

          attribute :timestamp,
                    :avg_cargotk1,
                    :avg_cargotk2,
                    :avg_cargotk3,
                    :avg_cargotk4,
                    :vessel_name,
                    :selected_voyage_no,
                    :view_day, :all_voyages, :voyage_props
        end
      end
    end
  end
end
