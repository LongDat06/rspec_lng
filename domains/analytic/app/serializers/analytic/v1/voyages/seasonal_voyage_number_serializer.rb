module Analytic
  module V1
    module Voyages
      class SeasonalVoyageNumberSerializer
        include FastJsonapi::ObjectSerializer
        set_type :seasonal_voyage_number_filter

        attribute :imo,
                  :vessel_name,
                  :data
      end
    end
  end
end
