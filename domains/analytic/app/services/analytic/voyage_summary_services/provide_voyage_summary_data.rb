module Analytic
  module VoyageSummaryServices
    class ProvideVoyageSummaryData
      ARRIVAL = '7:ARV'.freeze
      DEPT = '3:DEP'.freeze

      MODELING = Struct.new(
        :imo,
        :voyage_no,
        :voyage_leg,
        :port_dept,
        :atd_lt,
        :atd_utc,
        :port_arrival,
        :ata_lt,
        :ata_utc,
        :duration,
        :distance,
        :average_speed,
        :cargo_volume_at_port_of_arrival,
        :lng_consumption,
        :mgo_consumption,
        :average_boil_off_rate,
        :actual_heel,
        :adq,
        :manual_duration,
        :manual_average_speed,
        keyword_init: true
      )

      def initialize(imo:, voyage_no: nil, voyage_leg: nil)
        @imo = imo
        @voyage_no = voyage_no
        @voyage_leg = voyage_leg
      end

      def call
        data = []
        voyage_data.each do |item|
          addition_data = ProvideVoyageSummaryDataCalculator.new(imo: item[:imo],
                                                                 voyage_no: item[:voyage_no],
                                                                 voyage_leg: item[:voyage_leg],
                                                                 atd_utc: item[:atd_utc],
                                                                 ata_utc: item[:ata_utc]).call

          record = MODELING.new(imo: item[:imo],
                                voyage_no: item[:voyage_no],
                                voyage_leg: item[:voyage_leg],
                                atd_utc: item[:atd_utc],
                                ata_utc: item[:ata_utc],
                                port_dept: item[:port_dept],
                                atd_lt: item[:atd_lt],
                                port_arrival: item[:port_arrival],
                                ata_lt: item[:ata_lt],
                                duration: addition_data.duration,
                                distance: addition_data.distance,
                                average_speed: addition_data.average_speed,
                                cargo_volume_at_port_of_arrival: addition_data.cargo_volume_at_port_of_arrival,
                                lng_consumption: addition_data.lng_consumption,
                                mgo_consumption: addition_data.mgo_consumption,
                                average_boil_off_rate: addition_data.average_boil_off_rate,
                                actual_heel: addition_data.actual_heel,
                                adq: addition_data.adq,
                                manual_duration: addition_data.manual_duration,
                                manual_average_speed: addition_data.manual_average_speed)
          data << record
        end
        data
      end

      private

      def voyage_data
        @voyage_data ||= Analytic::Spas.collection.aggregate([match, sort, group]).map do |spas|
          group_id = spas['_id']
          {
            imo: group_id[:imo],
            voyage_no: group_id[:voyage_no],
            voyage_leg: group_id[:voyage_leg]
          }.merge(arrival_data(spas['items']))
            .merge(dept_data(spas['items']))
        end
      end

      def arrival_data(items)
        arrival_event = {}
        items.reverse_each do |item|
          if item[:category] == ARRIVAL
            arrival_event = item
            break
          end
        end
        {
          port_arrival: arrival_event[:port_name],
          ata_lt: arrival_event[:local_time],
          ata_utc: arrival_event[:utc_time]
        }
      end

      def dept_data(items)
        dept_event = items.find { |item| item[:category] == DEPT } || {}
        {
          port_dept: dept_event[:port_name],
          atd_lt: dept_event[:local_time],
          atd_utc: dept_event[:utc_time]
        }
      end

      def sort
        {
          "$sort": { "spec.ts": 1 }
        }
      end

      def match
        conditions = []
        conditions << { "imo_no": @imo }
        conditions << { "spec.jsmea_voy_voyageinformation_voyageno": @voyage_no } if @voyage_no.present?
        conditions << { "spec.jsmea_voy_voyageinformation_leg": @voyage_leg } if @voyage_leg.present?
        conditions << { "spec.jsmea_voy_voyageinformation_category": { "$in": [DEPT, ARRIVAL] } }
        { '$match' => conditions.reduce(:merge) }
      end

      def group
        {
          "$group": {
            "_id": { "imo": '$imo_no',
                     "voyage_no": '$spec.jsmea_voy_voyageinformation_voyageno',
                     "voyage_leg": '$spec.jsmea_voy_voyageinformation_leg' },
            "items": {
              "$push": {
                "ts": '$spec.ts',
                "category": '$spec.jsmea_voy_voyageinformation_category',
                "port_name": '$spec.jsmea_voy_portinformation_portname',
                "local_time": '$spec.jsmea_voy_dateandtime_lt',
                "utc_time": '$spec.jsmea_voy_dateandtime_utc'
              }
            }
          }
        }
      end
    end
  end
end
