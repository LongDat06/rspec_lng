module Analytic
  module EdqResultForms
    class HeelResult
      include ActiveModel::Validations
      include Virtus.model

      attribute :port_dept,                          String
      attribute :port_arrival,                       String
      attribute :pacific_route,                      String
      attribute :etd,                                DateTime
      attribute :eta,                                DateTime
      attribute :estimated_distance,                 Float
      attribute :voyage_duration,                    Float
      attribute :required_speed,                     Float
      attribute :estimated_daily_foc,                Float
      attribute :estimated_daily_foc_season_effect,  Float
      attribute :estimated_total_foc,                Float
      attribute :consuming_lng,                      Float

      validates_presence_of :port_dept,
                            :port_arrival,
                            :etd,
                            :eta,
                            :estimated_distance,
                            :voyage_duration,
                            :estimated_daily_foc,
                            :estimated_daily_foc_season_effect,
                            :consuming_lng

    end
  end
end
