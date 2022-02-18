module Analytic
  module V1
    module Voyages
      class SeasonalVoyageSummarySerializer
        include FastJsonapi::ObjectSerializer
        set_type :seasonal_voyage_summary_filter

        attribute :id,
                  :imo,
                  :vessel_name,
                  :voyage_no,
                  :atd_utc,
                  :ata_utc,
                  :closest_atd,
                  :closest_ata
      end
    end
  end
end
