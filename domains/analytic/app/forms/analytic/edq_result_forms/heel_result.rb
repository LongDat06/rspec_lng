module Analytic
  module EdqResultForms
    class HeelResult
      include ActiveModel::Validations
      include Virtus.model

      attribute :port_dept_id,                       Integer
      attribute :port_arrival_id,                    Integer
      attribute :master_route_id,                    Integer
      attribute :etd,                                DateTime
      attribute :etd_time_zone,                      String
      attribute :eta,                                DateTime
      attribute :eta_time_zone,                      String
      attribute :estimated_distance,                 Float
      attribute :voyage_duration,                    Float
      attribute :required_speed,                     Float
      attribute :estimated_daily_foc,                Float
      attribute :estimated_daily_foc_season_effect,  Float
      attribute :estimated_total_foc,                Float
      attribute :consuming_lng,                      Float

      validates_presence_of :port_dept_id,
                            :port_arrival_id,
                            :master_route_id,
                            :etd,
                            :etd_time_zone,
                            :eta,
                            :eta_time_zone,
                            :estimated_distance,
                            :voyage_duration,
                            :estimated_daily_foc,
                            :estimated_daily_foc_season_effect,
                            :consuming_lng

    end
  end
end
