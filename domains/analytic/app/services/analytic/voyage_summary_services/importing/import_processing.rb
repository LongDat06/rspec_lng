module Analytic
  module VoyageSummaryServices
    module Importing
      class ImportProcessingError < StandardError; end

      class ImportProcessing
        def initialize(imo:, voyage_no: nil, voyage_leg: nil)
          @imo = imo
          @voyage_no = voyage_no
          @voyage_leg = voyage_leg
        end

        def call
          data = []
          voyage_data.each do |item|
            data << Analytic::VoyageSummary.new(imo: item.imo,
                                                voyage_no: voyage_no_format(item.voyage_no),
                                                voyage_leg: item.voyage_leg.to_s.upcase,
                                                leg_id: item.leg_id,
                                                pacific_voyage: item.pacific_voyage,
                                                port_dept: port_name_format(item.port_dept),
                                                atd_lt: item.atd_lt,
                                                atd_utc: item.atd_utc,
                                                port_arrival: port_name_format(item.port_arrival),
                                                ata_lt: item.ata_lt,
                                                ata_utc: item.ata_utc,
                                                duration: item.duration,
                                                distance: item.distance,
                                                average_speed: item.average_speed,
                                                cargo_volume_at_port_of_arrival: item.cargo_volume_at_port_of_arrival,
                                                lng_consumption: item.lng_consumption,
                                                mgo_consumption: item.mgo_consumption,
                                                average_boil_off_rate: item.average_boil_off_rate,
                                                actual_heel: item.actual_heel,
                                                adq: item.adq,
                                                manual_duration: item.manual_duration,
                                                manual_average_speed: item.manual_average_speed)
          end

          Analytic::VoyageSummary.import data, on_duplicate_key_update: { conflict_target: %i(imo voyage_no voyage_leg leg_id),
                                                                          columns: update_columns } if data.present?

        end

        private

        def update_columns
          %i[pacific_voyage port_dept atd_lt atd_utc port_arrival ata_lt ata_utc duration distance average_speed
             cargo_volume_at_port_of_arrival lng_consumption mgo_consumption average_boil_off_rate
             actual_heel adq manual_duration manual_average_speed]
        end

        def voyage_data
          @voyage_data ||= Analytic::VoyageSummaryServices::ProvideVoyageSummaryData.new(imo: @imo,
                                                                                         voyage_no: @voyage_no&.to_i,
                                                                                         voyage_leg: @voyage_leg).call

        end

        def port_name_format(port)
          port.to_s.upcase.split(';')[0]&.strip
        end

        def voyage_no_format(no)
          return if no.blank?

          '%03d' % no.to_i
        end
      end
    end
  end
end
