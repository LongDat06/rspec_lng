module Analytic
  module V1
    module Charts
      module VoyageSummary
        class SummarySerializer
          include FastJsonapi::ObjectSerializer
          attribute :voyage_no,
                    :duration,
                    :distance,
                    :adq,
                    :average_speed,
                    :lng_consumption,
                    :mgo_consumption,
                    :avg_boil_off_rate,
                    :edq,
                    :actual_heel,
                    :estimated_heel,
                    :vessel_name,
                    :selected,
                    :is_average

        end
      end
    end
  end
end
