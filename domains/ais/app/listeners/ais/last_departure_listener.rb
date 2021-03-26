module Ais
  class LastDepartureListener
    def on_dep_successful(last_depature_data)
      vessel = Ais::Vessel.find_by(imo: last_depature_data[:imo])
      vessel.last_port_departure_at = last_depature_data[:spec][:jsmea_voy_dateandtime_lt]
      vessel.save!
    end
  end 
end
