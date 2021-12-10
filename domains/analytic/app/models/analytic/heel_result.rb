module Analytic
  class HeelResult < ApplicationRecord

    belongs_to :port_arrival, class_name: MasterPort.name, foreign_key: :port_arrival_id
    belongs_to :port_dept, class_name: MasterPort.name, foreign_key: :port_dept_id
    belongs_to :master_route, class_name: MasterRoute.name, foreign_key: :master_route_id

    def port_arrival_name
      port_arrival&.name
    end

    def port_dept_name
      port_dept&.name
    end

    def master_route_name
      master_route&.name
    end

    def etd_label
      etd_time_zone_label.label
    end

    def etd_utc
      etd_time_zone_label.time_utc
    end

    def eta_label
      eta_time_zone_label.label
    end

    def eta_utc
      eta_time_zone_label.time_utc
    end

    private

    def etd_time_zone_label
      @etd_time_zone_label ||= Analytic::HeelServices::TimezoneLabel.new(time: etd, time_zone: etd_time_zone).call
    end

    def eta_time_zone_label
      @eta_time_zone_label ||= Analytic::HeelServices::TimezoneLabel.new(time: eta, time_zone: eta_time_zone).call
    end

  end
end
