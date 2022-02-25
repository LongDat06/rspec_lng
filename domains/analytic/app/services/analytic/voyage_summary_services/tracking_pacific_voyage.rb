module Analytic
  module VoyageSummaryServices
    module TrackingPacificVoyage
      def fetching_pacific_voyage(imo, from_time, to_time)
        flag = false
        return flag if from_time.blank? && to_time.blank?
        from_time = (from_time.blank? && to_time.present?) ? (to_time.to_datetime - 30.days) : from_time
        to_time = (to_time.blank? && from_time.present?) ? (from_time.to_datetime + 30.days) : to_time
        tracking = Ais::Tracking.closest_time(from_time, imo)
        from_time = tracking&.last_ais_updated_at

        vessel = Ais::Vessel.find_by(imo: imo)
        from_time = from_time.presence || vessel.last_port_departure_at
        to_time = to_time.presence || Time.current.utc

        trackings = Ais::TrackingServices::TrackingPerHour.new(
          from_time: from_time,
          to_time: to_time,
          imo: imo
        ).get

        i = 0
        while i < trackings.size - 1
          if trackings[i].longitude.abs > 90 && trackings[i+1].longitude.abs > 90 &&
            ((trackings[i].longitude > 0 && trackings[i+1].longitude < 0) || (trackings[i].longitude < 0 && trackings[i+1].longitude > 0))
            flag = true
            break
          end
          i += 1
        end
        return flag
      end
    end
  end
end