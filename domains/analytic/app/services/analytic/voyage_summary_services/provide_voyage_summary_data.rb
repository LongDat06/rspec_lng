module Analytic
  module VoyageSummaryServices
    class ProvideVoyageSummaryData
      ARRIVAL = '7:ARV'.freeze
      DEPT = '3:DEP'.freeze

      MODELING = Struct.new(
        :id,
        :imo,
        :voyage_no,
        :voyage_leg,
        :leg_id,
        :pacific_voyage,
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
        voyage_data.each_with_index do |item, index|
          addition_data = ProvideVoyageSummaryDataCalculator.new(imo: item[:imo],
                                                                 voyage_no: item[:voyage_no],
                                                                 voyage_leg: item[:voyage_leg],
                                                                 leg_id: index + 1,
                                                                 atd_utc: item[:atd_utc],
                                                                 ata_utc: item[:ata_utc],
                                                                 panama_transit: voyage_data.size > 1).call

          record = MODELING.new(imo: item[:imo],
                                voyage_no: item[:voyage_no],
                                voyage_leg: item[:voyage_leg],
                                leg_id: index + 1,
                                pacific_voyage: addition_data.pacific_voyage,
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
        return @voyage_data if @voyage_data.present?
        voyage_data = []
        Analytic::Spas.collection.aggregate([match, sort, group_time, group]).map do |spas|
          group_id = spas['_id']
          items = spas['items'].sort_by {|item| item[:utc_time]}

          voyage_data << {
            imo: group_id[:imo],
            voyage_no: group_id[:voyage_no],
            voyage_leg: group_id[:voyage_leg]
          }.merge(first_dept_data(items))
           .merge(first_arrival_data(items))

          voyage_data << {
            imo: group_id[:imo],
            voyage_no: group_id[:voyage_no],
            voyage_leg: group_id[:voyage_leg]
          }.merge(last_dept_data(items))
           .merge(last_arrival_data(items)) if items.size > 2
        end
        voyage_data
        @voyage_data ||= voyage_data
      end

      def first_arrival_data(items)
        arrival_event = find_first_event(items, ARRIVAL)
        last_dept_event = find_last_event(items, DEPT) #last_dept_data(items)
        return {} if (arrival_event[:utc_time].present? && last_dept_event[:utc_time].present? &&
                        arrival_event[:utc_time].to_datetime >= last_dept_event[:utc_time].to_datetime) && items.size > 2

        {
          port_arrival: arrival_event[:port_name],
          ata_lt: arrival_event[:local_time],
          ata_utc: arrival_event[:utc_time]
        }
      end

      def last_arrival_data(items)
        arrival_event = find_last_event(items, ARRIVAL)
        last_dept_event = find_last_event(items, DEPT)#last_dept_data(items)
        return {} if (arrival_event[:utc_time].present? && last_dept_event[:utc_time].present? &&
                        arrival_event[:utc_time].to_datetime <= last_dept_event[:utc_time].to_datetime) && items.size > 2

        {
          port_arrival: arrival_event[:port_name],
          ata_lt: arrival_event[:local_time],
          ata_utc: arrival_event[:utc_time]
        }
      end

      def first_dept_data(items)
        dept_event = find_first_event(items, DEPT)
        first_arrival_event = find_first_event(items, ARRIVAL) #first_arrival_data(items)
        return {} if (dept_event[:utc_time].present? && first_arrival_event[:utc_time].present? &&
                        dept_event[:utc_time].to_datetime > first_arrival_event[:utc_time].to_datetime) && items.size > 2

        {
          port_dept: dept_event[:port_name],
          atd_lt: dept_event[:local_time],
          atd_utc: dept_event[:utc_time]
        }
      end

      def last_dept_data(items)
        dept_event = find_last_event(items, DEPT)
        first_dept_event = find_first_event(items, DEPT)#first_dept_data(items)
        return {} if (dept_event[:utc_time].present? && first_dept_event[:utc_time].present? &&
                      dept_event[:utc_time].to_datetime <= first_dept_event[:utc_time].to_datetime) && items.size > 2
        {
          port_dept: dept_event[:port_name],
          atd_lt: dept_event[:local_time],
          atd_utc: dept_event[:utc_time]
        }
      end

      def find_last_event(items, event_type)
        event = {}
        items.reverse_each do |item|
          if item[:category] == event_type
            event = item
            break
          end
        end
        event
      end

      def find_first_event(items, event_type)
        items.find { |item| item[:category] == event_type } || {}
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

      def group_time
        {"$group": {
            "_id": { "imo": '$imo_no', "ts": "$spec.ts"},
                    "category": {"$last": '$spec.jsmea_voy_voyageinformation_category'},
                    "port_name": {"$last": '$spec.jsmea_voy_portinformation_portname'},
                    "local_time": {"$last": '$spec.jsmea_voy_dateandtime_lt'},
                    "utc_time": {"$last": '$spec.jsmea_voy_dateandtime_utc'},
                      "imo": {"$last": '$imo_no'},
                     "voyage_no": {"$last": '$spec.jsmea_voy_voyageinformation_voyageno'},
                     "voyage_leg": {"$last": '$spec.jsmea_voy_voyageinformation_leg'},
          }
        }
      end

      def group
        {
          "$group": {
            "_id": { "imo": '$imo',
                     "voyage_no": '$voyage_no',
                     "voyage_leg": '$voyage_leg'
                    },
            "items": {
              "$push": {
                "ts": '$ts',
                "category": '$category',
                "port_name": '$port_name',
                "local_time": '$local_time',
                "utc_time": '$utc_time'
              }
            }
          }
        }
      end
    end
  end
end
